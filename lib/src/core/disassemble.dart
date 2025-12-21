import 'disassemble_to_groups.dart';

String disassemble(String str) {
  return disassembleToGroups(str).map((group) => group.join('')).join('');
}
