/// -----
/// [概要]   : 顧客情報のエンティティ
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/27
/// -----
/// 顧客の基本情報を表します。
class CustomerInfo {
  final int? customerId;
  final String? familyName;
  final String? firstName;
  final String? phoneNumber;
  final String? address;
  final String? managementStore;
  final String? manager;

  const CustomerInfo({
    this.customerId,
    this.familyName,
    this.firstName,
    this.phoneNumber,
    this.address,
    this.managementStore,
    this.manager,
  });
}

/// -----
/// [概要]   : 顧客検索条件のエンティティ
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/27
/// -----
/// 顧客を検索するための条件を保持します。
class CustomerSearchCondition {
  final String? kokyakuNm;
  final String? tel;
  final String? address;
  final String? kanriTenpo;
  final String? tantosha;

  const CustomerSearchCondition({this.kokyakuNm, this.tel, this.address, this.kanriTenpo, this.tantosha});

  CustomerSearchCondition copyWith({
    String? kokyakuNm,
    String? tel,
    String? address,
    String? kanriTenpo,
    String? tantosha,
  }) {
    return CustomerSearchCondition(
      kokyakuNm: kokyakuNm ?? this.kokyakuNm,
      tel: tel ?? this.tel,
      address: address ?? this.address,
      kanriTenpo: kanriTenpo ?? this.kanriTenpo,
      tantosha: tantosha ?? this.tantosha,
    );
  }
}
