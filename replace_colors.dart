import 'dart:io';

void main() {
  final dir = Directory('lib/presentation');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    String content = file.readAsStringSync();
    if (content.contains('AppColors.')) {
      content = content.replaceAll('AppColors.', 'context.colors.');
      file.writeAsStringSync(content);
      print('Updated ' + file.path);
    }
  }
}
