class Travel {
  final String nome;
  final String weekDays;

  Travel({required this.nome, required this.weekDays});

  factory Travel.fromRTDB(Map<String, dynamic> data) {
    var dias = data['dias'];
    String days = '';
    if(dias['dom']){
      days+='Dom,';
    }
    if(dias['seg']){
      days+='Seg,';
    }
    if(dias['ter']){
      days+='Ter,';
    }
    if(dias['qua']){
      days+='Qua,';
    }
    if(dias['qui']){
      days+='Qui,';
    }
    if(dias['sex']){
      days+='Sex,';
    }
    if(dias['sab']){
      days+='Sab,';
    }
    return Travel(nome: data['nome'], weekDays: days);
  }
}
