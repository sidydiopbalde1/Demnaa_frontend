import 'package:get/get.dart';
import '../../../models/delivery_model.dart';

class DeliveryController extends GetxController {
  var delivery = Delivery().obs;

  void updatePickupAddress(String value) => delivery.update((val) => val!.pickupAddress = value);
  void updateDestinationAddress(String value) => delivery.update((val) => val!.destinationAddress = value);
  void updateDestinationPhone(String value) => delivery.update((val) => val!.destinationPhone = value);
}