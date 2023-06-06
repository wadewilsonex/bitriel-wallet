String replaceRange(String? value, {int? length = 10}) {
  return value!.replaceRange(length!, value.length - 7, ".....");
}
