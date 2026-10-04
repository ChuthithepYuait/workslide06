<img width="301" height="412" alt="Screenshot 2026-10-04 185809" src="https://github.com/user-attachments/assets/6b805a16-002e-438c-8934-32490e4861d2" /># Flutter HTTP Worked Examples

โปรเจกต์นี้เป็นงานแยกสำหรับหัวข้อ HTTP Methods ใน Flutter ไม่เกี่ยวกับ Mini Project เดิม

## โครงสร้าง

- `lib/main.dart` — หน้าเมนู เปิดตัวอย่างทั้ง 5 ข้อ
<img width="299" height="521" alt="Screenshot 2026-10-04 185744" src="https://github.com/user-attachments/assets/305cb8eb-41d0-4fed-a7d9-0b1e8272ac43" />

- `lib/example1_get_users.dart` — GET รายการผู้ใช้
<img width="301" height="655" alt="Screenshot 2026-10-04 185749" src="https://github.com/user-attachments/assets/7d78d30b-1eec-4ef4-b2a8-9d7c17b71689" />
- `lib/example2_post_user.dart` — POST สร้างผู้ใช้
<img width="301" height="412" alt="Screenshot 2026-10-04 185809" src="https://github.com/user-attachments/assets/62ef90e8-8df6-43f6-9d42-f3e4fbd7e3d5" />
- `lib/example3_put_user.dart` — PUT แก้ไขผู้ใช้
<img width="299" height="340" alt="Screenshot 2026-10-04 185820" src="https://github.com/user-attachments/assets/b58daf4e-cf50-4642-99a1-25d6020cba65" />
- `lib/example4_delete_user.dart` — DELETE พร้อม Dialog ยืนยัน
<img width="302" height="913" alt="Screenshot 2026-10-04 185829" src="https://github.com/user-attachments/assets/b03c1f7d-538c-44d1-afd2-32b2d9b1cc28" />

- `lib/example5_search_posts.dart` — GET พร้อม Query Parameters
<img width="297" height="579" alt="Screenshot 2026-10-04 185852" src="https://github.com/user-attachments/assets/db3aa087-35b4-41a5-9afd-9f45097dde03" />

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
