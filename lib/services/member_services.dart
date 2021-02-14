import 'package:spring_superior/data/database.dart';
import 'package:spring_superior/models/member_model.dart';

class MemberServices{
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  createMember(Member member) async{
    final db = await dbHelper.database;
    db.insert(
      'memberInfoTable',
      member.toMap()
    );
  }

  updateMember(Member member) async{
    final db = await dbHelper.database;
    db.update(
        'memberInfoTable',
        member.toMap(),
      where: '_id=?',
      whereArgs: [member.id]
    );
  }

  deleteMember(Member member) async{
    final db = await dbHelper.database;
    db.delete(
        'memberInfoTable',
        where: '_id=?',
        whereArgs: [member.id]
    );
  }

  Future<List<Member>> getAllMembers() async{
    final db = await dbHelper.database;
    List<Map<String, dynamic>> allRows = await db.query('memberInfoTable');
    
    List<Member> membersList =  allRows.map((member) => Member.fromMap(member)).toList();
    return membersList;
  }

  Future<List<Member>> searchMembers(String keyword) async{
    final db = await dbHelper.database;
    List<Map<String, dynamic>> allRows = await db.query('memberInfoTable', where: 'name LIKE ?', whereArgs: ['%$keyword%']);

    List<Member> membersList =  allRows.map((member) => Member.fromMap(member)).toList();
    return membersList;
  }

  Future<List<Member>> getMemberActivity(String keyword) async{
    final db = await dbHelper.database;
    List<Map<String, dynamic>> allRows = await db.query('memberInfoTable', where: 'active LIKE ?', whereArgs: ['$keyword']);

    List<Member> membersList =  allRows.map((member) => Member.fromMap(member)).toList();
    return membersList;
  }

}