class Bus {
  int? busId;
  String? busNo;
  String? origin;
  String? through;
  String? destination;
  num? price;
  num? long;
  num? lat;
  String? lastUpdate;
  int? updateId;
  bool? active;

  Bus(
      {this.busId,
        this.busNo,
        this.origin,
        this.through,
        this.destination,
        this.price,
        this.long,
        this.lat,
        this.lastUpdate,
        this.updateId,
        this.active});

  Bus.fromJson(Map<String, dynamic> json) {
    busId = json['bus_id'];
    busNo = json['bus_no'];
    origin = json['origin'];
    through = json['through'];
    destination = json['destination'];
    price = json['price'];
    long = json['long'];
    lat = json['lat'];
    lastUpdate = json['last_update'];
    updateId = json['update_id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_id'] = this.busId;
    data['bus_no'] = this.busNo;
    data['origin'] = this.origin;
    data['through'] = this.through;
    data['destination'] = this.destination;
    data['price'] = this.price;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['last_update'] = this.lastUpdate;
    data['update_id'] = this.updateId;
    data['active'] = this.active;
    return data;
  }
}