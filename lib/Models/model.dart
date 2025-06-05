// class MdlStores {
//   final String? id;
//   final String storeProfile;
//   final String storeName;
//   final String location;
//   final String radius;
//   final String contactNumber;
//   final List<MdlProducts>? displayInformation;

//   MdlStores({
//     this.id,
//     required this.storeProfile,
//     required this.storeName,
//     required this.location,
//     required this.radius,
//     required this.contactNumber,
//     this.displayInformation,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'store_image': storeProfile,
//       'store_name': storeName,
//       'location': location,
//       'radius': radius,
//       'contact_number': contactNumber,
//       'display_information': displayInformation?.map((e) => e.toMap()).toList(),
//     };
//   }

//   factory MdlStores.fromMap(Map<String, dynamic> map) {
//     return MdlStores(
//       id: map['id'] ?? '',
//       storeProfile: map['store_image'] ?? '',
//       storeName: map['store_name'] ?? '',
//       location: map['location'] ?? '',
//       radius: map['radius'] ?? '',
//       contactNumber: map['contact_number'] ?? '',
//       displayInformation:
//           map['display_information'] != null
//               ? List<MdlProducts>.from(
//                 (map['display_information'] as List).map(
//                   (e) => MdlProducts.fromMap(e),
//                 ),
//               )
//               : null,
//     );
//   }
// }
