
class ArrayStack<T> {
  List<T> stack = [];
  
  void push(T object){
    stack.add(object);
  }
  T pop(){
    return stack.removeLast();
  }
}
