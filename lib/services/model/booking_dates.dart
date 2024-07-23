

class BookingDates{
  final String date;
 

 BookingDates({required this.date});

  factory BookingDates.fromJson(Map<String , dynamic> json) {
    return BookingDates(
      date: json['date']??'',
    
    );
  }
}