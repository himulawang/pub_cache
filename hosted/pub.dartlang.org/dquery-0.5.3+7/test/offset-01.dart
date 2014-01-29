import 'dart:html';
import 'package:dquery/dquery.dart';

void main() {
  
  final Point offset = $('#target').offset;
  
  final Element info = querySelector('#info');
  info.innerHtml = "${info.innerHtml} (${offset.x}, ${offset.y})";
  
  $('span').offset = offset;
  
}