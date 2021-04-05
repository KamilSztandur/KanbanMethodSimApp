abstract class SaveFileWriterInterface {
  void saveFileAs(String filename, String content);
  bool isNameAlreadyTaken(String filename);
}
