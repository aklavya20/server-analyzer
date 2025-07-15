import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const ServeranalyzerApp());
}

class ServeranalyzerApp extends StatelessWidget {
  const ServeranalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Serveranalyzer()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/server_analyzer.png', height: 150),
      ),
    );
  }
}

class Serveranalyzer extends StatefulWidget {
  const Serveranalyzer({super.key});

  @override
  State<StatefulWidget> createState() {
    return ServeranalyzerState();
  }
}

class ServeranalyzerState extends State<Serveranalyzer> {
  final TextEditingController commandController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController serverController = TextEditingController();
  String? selectedTargetSpec;
  String? selectedGeneralSettings;
  String? selectedTuning;
  String? selectedPortSpec;
  String? selectedlogging;
  String? selectedOutput;
  String? selectedTiming;
  String? selectedEvasion;
  String? selectedPlugin;
  String? selectedMisc;
  String? selectedConfiguration;
  String? selectedUpdates;
  String? selectedAuthentication;
  String? selectedMutate;
  String serverAddress = '';
  bool isScanning = false;
  final List<String> targetSelectionOptions = ['-host+', '-url+', '-vhost+'];
  final List<String> generalSettingsOptions = [
    '-Pause+',
    '-nolookup',
    '-nossl',
    '-noslash',
    '-no404',
    '-useproxy',
    '-usecookies',
  ];
  final List<String> tuningOptions = [
    '-Tuning+',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    'a',
    'b',
    'c',
    'd',
    'e',
    'x',
  ];
  final List<String> portSpecOptions = ['-port+'];
  final List<String> loggingOptions = [
    '-Save',
    '-Display+',
    '1',
    '2',
    '3',
    '4',
    'D',
    'E',
    'P',
    'S',
    'V',
  ];
  final List<String> pluginOptions = ['-Plugins+', '-list-plugins'];
  final List<String> authenticationOptions = ['-id+', '-key+', '-RSAcert+'];
  final List<String> mutateOptions = ['-mutate+', '-mutate-options'];
  final List<String> timingOptions = ['-maxtime+', '-timeout+'];
  final List<String> evasionOptions = [
    '-evasion+',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    'A',
    'B',
  ];
  final List<String> outputOptions = [
    '-output+',
    '-o',
    '-Format+csv',
    '-Format+json',
    '-Format+htm',
    '-Format+nbe',
    '-Format+sql',
    '-Format+txt',
    '-Format+xml',
  ];
  final List<String> miscOptions = [
    '-ipv4',
    '-ipv6',
    '-ssl',
    '-followredirects',
    '-4004code',
    '404string'
        '-Version',
    '-Help',
  ];
  final List<String> configurations = [
    '-config+',
    '-Option',
    '-check6'
        '-Cgidirs+',
  ];
  final List<String> updates = ['-ask', '-dbcheck'];

  void updateCommand() {
    String command = 'sudo nikto';
    if (selectedTargetSpec != null) command += ' $selectedTargetSpec';
    if (selectedGeneralSettings != null) command += ' $selectedGeneralSettings';
    if (selectedTuning != null) command += ' $selectedTuning';
    if (selectedPortSpec != null) command += ' $selectedPortSpec';
    if (selectedlogging != null) command += ' $selectedlogging';
    if (selectedOutput != null) command += ' $selectedOutput';
    if (selectedTiming != null) command += ' $selectedTiming';
    if (selectedEvasion != null) command += ' $selectedEvasion';
    if (selectedPlugin != null) command += ' $selectedPlugin';
    if (selectedMisc != null) command += '$selectedMisc';
    if (selectedConfiguration != null) command += ' $selectedConfiguration';
    if (selectedUpdates != null) command += '$selectedUpdates';
    if (selectedAuthentication != null) command += ' $selectedAuthentication';
    if (selectedMutate != null) command += '$selectedMutate';
    commandController.text = command;
  }

  Future<String> sendCommandtoServer(String command) async {
    final url = Uri.parse(serverAddress);
    final request = await http.post(url, body: {'command': command});
    if (request.statusCode == 200) {
      return request.body;
    } else {
      showToast("Error:${request.statusCode}");
      throw Exception("Failed to execute NIKTO Scan");
    }
  }

  Future<void> startScan() async {
    String command = commandController.text;
    String target = targetController.text;
    if (target.isEmpty) {
      showToast("Please enter a target.");
      return;
    }
    command += ' $target';
    commandController.text = command;
    setState(() {
      isScanning = true;
    });
    try {
      showToast("Scan Started on $target");
      final niktoOutput = await sendCommandtoServer(command);
      saveScan(niktoOutput);
    } catch (e) {
      showToast("Error executing scan: $e");
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> saveScan(String niktoOutput) async {
    String output = selectedOutput ?? 'txt';
    String fileExtension = '.txt';
    final outputFolder = await getApplicationDocumentsDirectory();
    final String outputFolderPath = outputFolder.path;
    switch (output) {
      case '-Format+txt':
        fileExtension = '.txt';
        break;
      case '-Format+xml':
        fileExtension = '.xml';
        break;
      case '-Format+json':
        fileExtension = '.json';
        break;
      case '-Format+htm':
        fileExtension = '.html';
        break;
      case '-Format+csv':
        fileExtension = '.csv';
        break;
      case '-Format+sql':
        fileExtension = '.sql';
        break;
      case '-Format+nbe':
        fileExtension = '.nbe';
        break;
    }
    final now = DateTime.now();
    final fileName = 'scan_result_${now.millisecondsSinceEpoch}$fileExtension';
    final filePath = '${outputFolder.path}/$fileName';
    final file = File(filePath);
    try {
      await file.create(recursive: true);
      await file.writeAsString(niktoOutput);
      showToast('File Saved to $outputFolderPath');
    } catch (e) {
      showToast("Scan Failed");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server Analyzer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.terminal_outlined),
            onPressed: () async {
              final newServer = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Server Address'),
                  content: TextField(
                    controller: serverController,
                    decoration: InputDecoration(
                        hintText: "Enter server address",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(11),
                        )),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          setState(() {
                            serverAddress = serverController.text;
                          });
                          Navigator.pop(context);
                        }),
                  ],
                ),
              );
              if (newServer != null) {
                setState(() {
                  serverAddress = newServer;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
                left: 6.0,
                right: 6.0,
                bottom: 0.0,
              ),
              child: TextField(
                controller: commandController,
                decoration: InputDecoration(
                  labelText: 'Command',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextField(
                controller: targetController,
                decoration: InputDecoration(
                  hintText: 'ip.of.the.target or domain name',
                  labelText: 'Target',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            buildDropdownRow(
              'Target Selction',
              targetSelectionOptions,
              'General Settings',
              generalSettingsOptions,
              (value) {
                setState(() {
                  selectedTargetSpec = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedGeneralSettings = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Tuning',
              tuningOptions,
              'Port Specification',
              portSpecOptions,
              (value) {
                setState(() {
                  selectedTuning = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedPortSpec = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Logging Option',
              loggingOptions,
              'Output',
              outputOptions,
              (value) {
                setState(() {
                  selectedlogging = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedOutput = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Timing',
              timingOptions,
              'Evasion',
              evasionOptions,
              (value) {
                setState(() {
                  selectedTiming = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedEvasion = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Plugin',
              pluginOptions,
              'Misc',
              miscOptions,
              (value) {
                setState(() {
                  selectedPlugin = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedMisc = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Configurations',
              configurations,
              'Updates',
              updates,
              (value) {
                setState(() {
                  selectedConfiguration = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedUpdates = value;
                  updateCommand();
                });
              },
            ),
            buildDropdownRow(
              'Authentication',
              authenticationOptions,
              'Mutate',
              mutateOptions,
              (value) {
                setState(() {
                  selectedAuthentication = value;
                  updateCommand();
                });
              },
              (value) {
                setState(() {
                  selectedMutate = value;
                  updateCommand();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: ElevatedButton(
                onPressed: () {
                  startScan();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 60),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isScanning
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dns, color: Colors.grey),
            label: "NIKTO",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "SCAN RESULT",
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Serveranalyzer()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ScanResult()),
            );
          }
        },
      ),
    );
  }

  Widget buildDropdownRow(
    String label1,
    List<String> options1,
    String label2,
    List<String> options2,
    ValueChanged<String?> onChanged1,
    ValueChanged<String?> onChanged2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label1),
                  DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text('Select'),
                    items: options1
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label2),
                  DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text('Select'),
                    items: options2
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanResult extends StatefulWidget {
  const ScanResult({super.key});

  @override
  State<StatefulWidget> createState() {
    return ScanResultState();
  }
}

class ScanResultState extends State<ScanResult> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Server Analyzer"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.code_off), text: "XML"),
              Tab(icon: Icon(Icons.list_alt), text: "TEXT"),
              Tab(icon: Icon(Icons.html_outlined), text: "HTML"),
              Tab(icon: Icon(Icons.javascript), text: "JSON"),
              Tab(icon: Icon(Icons.storage), text: "SQL"),
              Tab(icon: Icon(Icons.drive_file_move), text: "CSV"),
              Tab(icon: Icon(Icons.security_outlined), text: "NBE"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScanFileList(extension: 'xml'),
            ScanFileList(extension: 'txt'),
            ScanFileList(extension: 'html'),
            ScanFileList(extension: 'json'),
            ScanFileList(extension: 'sql'),
            ScanFileList(extension: 'csv'),
            ScanFileList(extension: 'nbe'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dns, color: Colors.grey),
              label: "NIKTO",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: "SCAN RESULT",
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Serveranalyzer()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScanResult()),
              );
            }
          },
        ),
      ),
    );
  }
}

class ScanFileList extends StatefulWidget {
  final String extension;
  const ScanFileList({required this.extension, Key? key}) : super(key: key);

  @override
  State<ScanFileList> createState() => _ScanFileListState();
}

class _ScanFileListState extends State<ScanFileList> {
  List<File> allFiles = [];
  List<File> filteredFiles = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFiles();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(widget.extension))
        .toList();

    setState(() {
      allFiles = files;
      filteredFiles = files;
      isLoading = false;
    });
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFiles = allFiles
          .where(
              (file) => file.path.split('/').last.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search files',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredFiles.isEmpty
              ? const Center(child: Text('No files found.'))
              : ListView.builder(
                  itemCount: filteredFiles.length,
                  itemBuilder: (context, index) {
                    final file = filteredFiles[index];
                    return ListTile(
                      title: Text(file.path.split('/').last),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScanDetailPage(file: file),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          await Share.shareXFiles(
                            [XFile(file.path)],
                            text:
                                'Sharing scan result file: ${file.path.split('/').last}',
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ScanDetailPage extends StatelessWidget {
  final File file;
  const ScanDetailPage({required this.file, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extension = file.path.split('.').last;
    return Scaffold(
      appBar: AppBar(title: Text(file.path.split('/').last)),
      body: FutureBuilder<String>(
        future: file.readAsString(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final content = snapshot.data!;
          if (extension == 'xml') {
            return SingleChildScrollView(child: Text(content));
          } else if (extension == 'txt' || extension == 'grepable') {
            return SingleChildScrollView(child: Text(content));
          } else if (extension == 'html') {
            return SingleChildScrollView(child: Text(content));
          } else if (extension == 'csv' ||
              extension == 'json' ||
              extension == 'sql' ||
              extension == 'nbe') {
            return SingleChildScrollView(child: Text(content));
          } else {
            return const Center(child: Text("Unsupported format"));
          }
        },
      ),
    );
  }
}
