class ApiResponse<T>{
  T data;
  bool error;
  String errorMsg;
  ApiResponse({this.data,this.error=false, this.errorMsg,});
}