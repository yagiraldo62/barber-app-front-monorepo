import 'dart:convert';

import 'package:core/data/models/artist_location_model.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/artist_week_day_availability.dart';
import 'package:core/data/models/user_model.dart';

class ArtistModel {
  ArtistModel({
    this.name = '',
    this.id = '',
    this.categories,
    this.owner,
    this.availability,
    this.locations,
  });

  String id;
  UserModel? owner;
  String name;
  String? photoUrl;
  bool isOrganization = false;
  bool isInitialized = false;
  bool isPublished = false;
  List<CategoryModel>? categories = [];
  List<ArtistWeekDayAvailabilityModel>? availability = [];
  List<ArtistModel>? team = [];
  List<ArtistLocationModel>? locations = [];
  String description = '';
  String title = '';
  // List<AppointmentDatetimeModel>? pendingAppointments = [];

  factory ArtistModel.fromJson(Map<String, dynamic> jsonData) {
    return ArtistModel()
      ..id = jsonData['id'] as String? ?? ""
      ..owner =
          jsonData['owner'] != null
              ? UserModel.fromJson(jsonData['owner'])
              : null
      ..name = jsonData['name'] as String? ?? ""
      ..photoUrl = jsonData['photo_url'] as String? ?? ""
      ..isOrganization = jsonData['is_organization'] as bool? ?? false
      ..isInitialized = jsonData['is_initialized'] as bool? ?? false
      ..isPublished = jsonData['is_published'] as bool? ?? false
      ..categories = CategoryModel.listFromJson(jsonData['categories'])
      ..locations = ArtistLocationModel.listFromJson(jsonData['locations'])
      ..description = jsonData['description'] as String? ?? ""
      ..title = jsonData['title'] as String? ?? "";
    // ..availability =
    //     ArtistWeekDayAvailabilityModel.listFromJson(jsonData['availability']);
    // ..pendingAppointments = AppointmentDatetimeModel.listFromJson(
    //     jsonData['pending_appointments']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'owner': owner?.toJson(), // Assuming UserModel has a toJson method
      'name': name,
      'photo_url': photoUrl,
      'is_organization': isOrganization,
      'is_initialized': isInitialized,
      'is_published': isPublished,
      'categories': categories?.map((category) => category.toJson()).toList(),
      'availability':
          availability
              ?.map((availabilityModel) => availabilityModel.toJson())
              .toList(),
      'team': team?.map((teamMember) => teamMember.toJson()).toList(),
      'locations': locations?.map((location) => location.toJson()).toList(),
      'description': description,
      'title': title,
      // 'pensding_appointments': pendingAppointments
      //     ?.map((appointment) => appointment.toJson())
      //     .toList(),
    };
    return data;
  }

  Map<String, dynamic> toSimplifiedJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'owner_id': owner?.id,
      'photo_url': photoUrl,
      'is_organization': isOrganization,
      'is_initialized': isInitialized,
      'is_published': isPublished,
      // 'categories': categories?.map((category) => category.toJson()).toList(),
      'availability':
          json
              .encode(
                availability
                    ?.map((availabilityModel) => availabilityModel.toJson())
                    .toList(),
              )
              .toString(),
      'description': description,
      'title': title,
      // 'team': team?.map((teamMember) => teamMember.toJson()).toList(),
      // 'pendingAppointments': pendingAppointments
      //     ?.map((appointment) => appointment.toJson())
      //     .toList(),
    };
    return data;
  }

  // void addPendingAppointments(List<AppointmentDatetimeModel> newAppointments) {
  //   pendingAppointments ??= <AppointmentDatetimeModel>[];

  //   newAppointments.map((AppointmentDatetimeModel newAppointment) {
  //     AppointmentDatetimeModel? existingAppointment =
  //         pendingAppointments?.firstWhereOrNull((pendingAppointment) =>
  //             pendingAppointment.id == newAppointment.id);

  //     if (existingAppointment == null) {
  //       pendingAppointments!.add(newAppointment);
  //     }
  //   }).toList();
  // }

  static List<ArtistModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData.map((artist) => ArtistModel.fromJson(artist)).toList()
          : [];
}
