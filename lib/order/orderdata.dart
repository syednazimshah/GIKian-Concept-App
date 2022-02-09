

class itemdata {
  String name='';
  int number=0;
  int price=0;
  itemdata({required this.name,required this.price, required this.number});
}

class orderlist{
  List <itemdata> datalist=[];
  int totalorders=0;
  int totalprice=0;



  orderlist();
  String addorder (String name, int price){
    for(int i=0;i<datalist.length;i++){
      if(datalist[i].name==name){
        datalist[i].number++;
        totalorders++;
        totalprice=totalprice+price;
        return 'Item added Successfully!';
      }
    }
    itemdata temp= new itemdata(name: name, price: price, number: 1);
    datalist.add(temp);
    totalprice=totalprice+price;
    totalorders++;
    return 'Item added Successfully!';
  }

  String removeorder(String name, int price){
    for(int i=0;i<datalist.length;i++){
      if(datalist[i].name==name){
        datalist[i].number--;
        if(datalist[i].number==0){
          datalist.removeAt(i);
        }
        totalorders--;
        totalprice=totalprice-price;
        return 'Item removed Successfully!';
      }
    }
    return 'Item not found!';
  }

}