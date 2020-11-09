abstract class PageChangeEvent {}

class onPageChangeEvent extends PageChangeEvent {
  final int pageNumber;

  onPageChangeEvent({this.pageNumber});
}
