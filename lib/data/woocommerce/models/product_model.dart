import 'package:flutter/material.dart';
import 'package:openflutterecommerce/data/abstract/model/product_attribute.dart';
import 'package:openflutterecommerce/domain/entities/product/product_entity.dart';

class ProductModel extends ProductEntity {

  ProductModel(
    {@required int id,
    @required title,
    @required subTitle,
    @required description,
    @required images,
    @required price,
    @required salePrice,
    @required thumb,
    @required selectableAttributes,
    rating,
    categoryId,
    orderNumber,
    count}) : super(
      id: id, 
      title: title,
      subTitle: subTitle,
      price: price,
      discountPercent: salePrice != 0 ? ((price - salePrice)/price*100 as num).round() : 0,
      description: description,
      selectableAttributes: selectableAttributes,
      images: images,
      thumb: thumb,
      rating: rating
    );
      
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if ( json['images']!=null ) {
      (json['images'] as List).forEach((f) => images.add(f['src']));
    }
    return ProductModel(
      id: (json['id'] as num).toInt(), 
      title: json['name'],
      subTitle: json['categories']!=null? json['categories'][0]['name']:'',
      description: stripTags(json['description']),
      rating: json['average_rating'] !=null ? double.parse(json['average_rating']) : 0,
      images: images,
      price: json['regular_price'] !=null && json['regular_price'] != '' ? 
        double.parse(json['regular_price']) : 0,
      salePrice: json['sale_price'] !=null && json['sale_price'] != '' ? 
        double.parse(json['sale_price']) : 0,
      thumb: json['images']!=null ? json['images'][0]['src'] : '',
      //TODO: add all categories related to product
      categoryId: json['categories']!=null? (json['categories'][0]['id'] as num).toInt():0, 
      orderNumber: (json['menu_order'] as num).toInt(),
      selectableAttributes: _getSelectableAttributesFromJson(json)
    );
  }

  static List<ProductAttribute> _getSelectableAttributesFromJson(Map<String, dynamic> json){
    List<ProductAttribute> selectableAttributes = [];
    if ( json['attributes']!= null ) {
       for (var attribute in json['attributes']) {
        selectableAttributes.add(
          ProductAttribute(
            id: attribute['id']??0,
            name: attribute['name']??'',
            options: List<String>.from(attribute['options'])
          )
        );
      }
    }
    return selectableAttributes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'name': title,
      'description': description,
      'image': {
        'src': images.isNotEmpty?images[0]:'',
      }
    };
  }
  static String stripTags(String htmlText) {
    RegExp exp = RegExp(
        r'<[^>]*>',
        multiLine: true,
        caseSensitive: true
      );
    return htmlText.replaceAll(exp, '');
  }
}
