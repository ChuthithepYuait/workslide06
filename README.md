# Flutter HTTP Worked Examples

โปรเจกต์นี้เป็นงานแยกสำหรับหัวข้อ HTTP Methods ใน Flutter ไม่เกี่ยวกับ Mini Project เดิม

## โครงสร้าง

- `lib/main.dart` — หน้าเมนู เปิดตัวอย่างทั้ง 5 ข้อ
- `lib/example1_get_users.dart` — GET รายการผู้ใช้
- `lib/example2_post_user.dart` — POST สร้างผู้ใช้
- `lib/example3_put_user.dart` — PUT แก้ไขผู้ใช้
- `lib/example4_delete_user.dart` — DELETE พร้อม Dialog ยืนยัน
- `lib/example5_search_posts.dart` — GET พร้อม Query Parameters

## API ที่ใช้

ใช้ JSONPlaceholder สำหรับสาธิต API:
`https://jsonplaceholder.typicode.com`

## วิธีรัน

1. เปิดโฟลเดอร์โปรเจกต์ด้วย Android Studio
2. เปิด Android Emulator
3. เปิด Terminal ในโฟลเดอร์โปรเจกต์
4. รัน:

```bash
flutter pub get
flutter run
```

หรือกด Run ใน Android Studio

## หมายเหตุ

JSONPlaceholder เป็น API สาธิต ดังนั้น POST/PUT/DELETE จะตอบกลับเหมือนการทำงานสำเร็จเพื่อใช้ทดลอง แต่ไม่ได้เป็นฐานข้อมูลจริงที่เก็บการเปลี่ยนแปลงถาวร

## สิ่งที่ตรงกับโจทย์

### ตัวอย่าง 1 — GET
- `http.get`
- ตรวจ `statusCode == 200`
- `jsonDecode(...) as List<dynamic>`
- `throw Exception(...)` เมื่อไม่สำเร็จ
- timeout 10 วินาที

### ตัวอย่าง 2 — POST
- `http.post`
- `Content-Type: application/json`
- `jsonEncode(...)`
- ตรวจ `statusCode == 201`
- decode เป็น `Map<String, dynamic>`

### ตัวอย่าง 3 — PUT
- `http.put`
- ใส่ `id` ใน path
- ส่ง JSON body
- คืน `true` เมื่อ `statusCode == 200`

### ตัวอย่าง 4 — DELETE
- `showDialog<bool>` ขอการยืนยัน
- ไม่ยืนยันจะไม่ลบ
- `http.delete`
- แจ้งผลด้วย `SnackBar`

### ตัวอย่าง 5 — Search
- `Uri.parse(...).replace(queryParameters: ...)`
- ส่ง `q` และ `_limit`
- คืนรายการผลลัพธ์
