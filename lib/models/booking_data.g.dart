// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingDataAdapter extends TypeAdapter<BookingData> {
  @override
  final int typeId = 0;

  @override
  BookingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingData(
      id: fields[0] as String,
      hotelTitle: fields[1] as String,
      hotelLocation: fields[2] as String,
      hotelImagePath: fields[3] as String,
      hotelRating: fields[4] as double,
      hotelPricePerNight: fields[5] as int,
      numberOfPeople: fields[6] as int,
      checkInDate: fields[7] as DateTime,
      checkOutDate: fields[8] as DateTime,
      numberOfGuests: fields[9] as int,
      totalPrice: fields[10] as double,
      guestName: fields[11] as String,
      guestEmail: fields[12] as String,
      guestPhone: fields[13] as String,
      bookingDate: fields[14] as DateTime,
      status: fields[15] as String,
      specialRequests: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingData obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hotelTitle)
      ..writeByte(2)
      ..write(obj.hotelLocation)
      ..writeByte(3)
      ..write(obj.hotelImagePath)
      ..writeByte(4)
      ..write(obj.hotelRating)
      ..writeByte(5)
      ..write(obj.hotelPricePerNight)
      ..writeByte(6)
      ..write(obj.numberOfPeople)
      ..writeByte(7)
      ..write(obj.checkInDate)
      ..writeByte(8)
      ..write(obj.checkOutDate)
      ..writeByte(9)
      ..write(obj.numberOfGuests)
      ..writeByte(10)
      ..write(obj.totalPrice)
      ..writeByte(11)
      ..write(obj.guestName)
      ..writeByte(12)
      ..write(obj.guestEmail)
      ..writeByte(13)
      ..write(obj.guestPhone)
      ..writeByte(14)
      ..write(obj.bookingDate)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.specialRequests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}