class AllCategoryList {
  List<String> allCategories = List<String>();
  AllCategoryList(var decodedData) {
    List category = decodedData;
    for (int i = 0; i < category.length; i++) {
      var a = category[i];
      allCategories.add(a);
    }
  }
  List<String> getCategoryList() {
    return allCategories;
  }
}
