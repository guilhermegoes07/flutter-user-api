class User {
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final Dob dob;
  final Registered registered;
  final String phone;
  final String cell;
  final Id id;
  final Picture picture;
  final String nat;

  const User({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      gender: json['gender'] ?? '',
      name: Name.fromJson(json['name'] as Map<String, dynamic>?),
      location: Location.fromJson(json['location'] as Map<String, dynamic>?),
      email: json['email'] ?? '',
      login: Login.fromJson(json['login'] as Map<String, dynamic>?),
      dob: Dob.fromJson(json['dob'] as Map<String, dynamic>?),
      registered: Registered.fromJson(json['registered'] as Map<String, dynamic>?),
      phone: json['phone'] ?? '',
      cell: json['cell'] ?? '',
      id: Id.fromJson(json['id'] as Map<String, dynamic>?),
      picture: Picture.fromJson(json['picture'] as Map<String, dynamic>?),
      nat: json['nat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name.toJson(),
      'location': location.toJson(),
      'email': email,
      'login': login.toJson(),
      'dob': dob.toJson(),
      'registered': registered.toJson(),
      'phone': phone,
      'cell': cell,
      'id': id.toJson(),
      'picture': picture.toJson(),
      'nat': nat,
    };
  }

  Map<String, dynamic> toPersistenceMap() {
    return {
      'gender': gender,
      'name_title': name.title,
      'name_first': name.first,
      'name_last': name.last,
      'location_street_number': location.street.number,
      'location_street_name': location.street.name,
      'location_city': location.city,
      'location_state': location.state,
      'location_country': location.country,
      'location_postcode': location.postcode,
      'location_coordinates_latitude': location.coordinates.latitude,
      'location_coordinates_longitude': location.coordinates.longitude,
      'location_timezone_offset': location.timezone.offset,
      'location_timezone_description': location.timezone.description,
      'email': email,
      'login_uuid': login.uuid,
      'login_username': login.username,
      'login_password': login.password,
      'login_salt': login.salt,
      'login_md5': login.md5,
      'login_sha1': login.sha1,
      'login_sha256': login.sha256,
      'dob_date': dob.date,
      'dob_age': dob.age,
      'registered_date': registered.date,
      'registered_age': registered.age,
      'phone': phone,
      'cell': cell,
      'id_name': id.name,
      'id_value': id.value,
      'picture_large': picture.large,
      'picture_medium': picture.medium,
      'picture_thumbnail': picture.thumbnail,
      'nat': nat,
    };
  }

  static User fromPersistenceMap(Map<String, dynamic> map) {
    return User(
      gender: map['gender'] as String? ?? '',
      name: Name(
        title: map['name_title'] as String? ?? '',
        first: map['name_first'] as String? ?? '',
        last: map['name_last'] as String? ?? '',
      ),
      location: Location(
        street: Street(
          number: (map['location_street_number'] as num?)?.toInt() ?? 0,
          name: map['location_street_name'] as String? ?? '',
        ),
        city: map['location_city'] as String? ?? '',
        state: map['location_state'] as String? ?? '',
        country: map['location_country'] as String? ?? '',
        postcode: map['location_postcode'] as String? ?? '',
        coordinates: Coordinates(
          latitude: map['location_coordinates_latitude'] as String? ?? '',
          longitude: map['location_coordinates_longitude'] as String? ?? '',
        ),
        timezone: Timezone(
          offset: map['location_timezone_offset'] as String? ?? '',
          description: map['location_timezone_description'] as String? ?? '',
        ),
      ),
      email: map['email'] as String? ?? '',
      login: Login(
        uuid: map['login_uuid'] as String? ?? '',
        username: map['login_username'] as String? ?? '',
        password: map['login_password'] as String? ?? '',
        salt: map['login_salt'] as String? ?? '',
        md5: map['login_md5'] as String? ?? '',
        sha1: map['login_sha1'] as String? ?? '',
        sha256: map['login_sha256'] as String? ?? '',
      ),
      dob: Dob(
        date: map['dob_date'] as String? ?? '',
        age: (map['dob_age'] as num?)?.toInt() ?? 0,
      ),
      registered: Registered(
        date: map['registered_date'] as String? ?? '',
        age: (map['registered_age'] as num?)?.toInt() ?? 0,
      ),
      phone: map['phone'] as String? ?? '',
      cell: map['cell'] as String? ?? '',
      id: Id(
        name: map['id_name'] as String? ?? '',
        value: map['id_value'] as String? ?? '',
      ),
      picture: Picture(
        large: map['picture_large'] as String? ?? '',
        medium: map['picture_medium'] as String? ?? '',
        thumbnail: map['picture_thumbnail'] as String? ?? '',
      ),
      nat: map['nat'] as String? ?? '',
    );
  }
}

class Name {
  final String title;
  final String first;
  final String last;

  const Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Name(
      title: data['title']?.toString() ?? '',
      first: data['first']?.toString() ?? '',
      last: data['last']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }
}

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  const Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Location(
      street: Street.fromJson(data['street'] as Map<String, dynamic>?),
      city: data['city']?.toString() ?? '',
      state: data['state']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      postcode: data['postcode']?.toString() ?? '',
      coordinates: Coordinates.fromJson(data['coordinates'] as Map<String, dynamic>?),
      timezone: Timezone.fromJson(data['timezone'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street.toJson(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toJson(),
      'timezone': timezone.toJson(),
    };
  }
}

class Street {
  final int number;
  final String name;

  const Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Street(
      number: (data['number'] as num?)?.toInt() ?? 0,
      name: data['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
    };
  }
}

class Coordinates {
  final String latitude;
  final String longitude;

  const Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Coordinates(
      latitude: data['latitude']?.toString() ?? '',
      longitude: data['longitude']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Timezone {
  final String offset;
  final String description;

  const Timezone({required this.offset, required this.description});

  factory Timezone.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Timezone(
      offset: data['offset']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'description': description,
    };
  }
}

class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  const Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Login(
      uuid: data['uuid']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
      salt: data['salt']?.toString() ?? '',
      md5: data['md5']?.toString() ?? '',
      sha1: data['sha1']?.toString() ?? '',
      sha256: data['sha256']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}

class Dob {
  final String date;
  final int age;

  const Dob({required this.date, required this.age});

  factory Dob.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Dob(
      date: data['date']?.toString() ?? '',
      age: (data['age'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'age': age,
    };
  }
}

class Registered {
  final String date;
  final int age;

  const Registered({required this.date, required this.age});

  factory Registered.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Registered(
      date: data['date']?.toString() ?? '',
      age: (data['age'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'age': age,
    };
  }
}

class Id {
  final String name;
  final String value;

  const Id({required this.name, required this.value});

  factory Id.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Id(
      name: data['name']?.toString() ?? '',
      value: data['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  const Picture({required this.large, required this.medium, required this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return Picture(
      large: data['large']?.toString() ?? '',
      medium: data['medium']?.toString() ?? '',
      thumbnail: data['thumbnail']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }
}
