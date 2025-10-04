enum ProductEnums { large, small, medium }

extension ProductEnumsExt on ProductEnums {
  String get trans {
    switch (this) {
      case ProductEnums.large:
        {
          return 'كبير';
        }
      case ProductEnums.medium:
        {
          return 'وسط';
        }
      case ProductEnums.small:
        {
          return 'صغير';
        }
    }
  }
}
