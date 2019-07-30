String removePrefixIfNeeded(String name) {
  if (name.isEmpty) return "";

  return name[0] == '@' ? name.substring(1) : name;
}
