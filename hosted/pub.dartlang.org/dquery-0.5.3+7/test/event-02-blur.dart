import 'dart:html';

import 'package:dquery/dquery.dart';

void main() {
  
  int docHit = 1;
  int elemHit = 1;
  
  final Element docRes = querySelector('#doc-result');
  final Element elemRes = querySelector('#elem-result');
  
  $document().on('blur', (DQueryEvent e) {
    docRes.innerHtml = '${docHit++}';
    
  }, selector: '#input');
  
  $('#input').on('blur', (DQueryEvent e) {
    elemRes.innerHtml = '${elemHit++}';
    
  });
  
}