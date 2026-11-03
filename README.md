# 📦 TKS Thực Tập V11 (WMS System)

Hệ thống Quản lý Kho (Warehouse Management System - WMS) hỗ trợ quản lý danh mục, các nghiệp vụ nhập kho, xuất kho và tổng hợp báo cáo nhập - xuất - tồn.

---

## 🛠️ Công Nghệ Sử Dụng

* **Framework:** ASP.NET Core Blazor Server (.NET 8.0)
* **Database:** SQL Server
* **UI Framework:** Telerik UI for Blazor

---

## 📋 Yêu Cầu Phần Mềm

Trước khi bắt đầu, hãy đảm bảo máy tính của bạn đã cài đặt:

* **.NET SDK:** Version 8.0
* **Database:** SQL Server 2019 trở lên & SQL Server Management Studio (SSMS)
* **IDE:** Visual Studio 2022+ (khuyên dùng) hoặc các IDE khác hỗ trợ .NET

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Dự Án

### Bước 1: Khôi phục Cơ sở dữ liệu (Restore Database)
1. Mở **SQL Server Management Studio (SSMS)** và đăng nhập bằng tài khoản **SQL Server Authentication**.
2. Nhấp chuột phải vào `Databases` ➔ Chọn **Restore Database...**
3. Tại mục **Device**, bấm chọn file `TKS_Thuc_Tap_V11.bak` để restore với tên Database là **`TKS_Thuc_Tap_V11`**.
4. *(Lưu ý)* Nếu xảy ra lỗi đường dẫn, kiểm tra tab **Files** và sửa lại đường dẫn các file `.mdf` và `.ldf` tương ứng với thư mục trên máy của bạn.
5. Bấm **OK** để hoàn tất khôi phục.

### Bước 2: Chạy File Cấu Hình (Scripts)
1. Mở **PowerShell** bằng quyền Administrator (**Run as Administrator**).
2. Copy nội dung file `scripts.txt` và thực thi trong PowerShell.

### Bước 3: Cấu Hình & Chạy Project
1. Mở file Solution (`.sln`) trong thư mục `TKS_Thuc_Tap_11` bằng Visual Studio.
2. Kiểm tra và cập nhật lại chuỗi kết nối (`ConnectionString`) trong file:
   `Web/appsettings.json`
3. Tiến hành **Build** và chạy project **`TKS_Thuc_Tap_V11_Web`**.

---

## 🔐 Tài Khoản Đăng Nhập Mặc Định

Sau khi chạy ứng dụng thành công, đăng nhập hệ thống bằng tài khoản Admin:

* **Tài khoản:** `admin`
* **Mật khẩu:** `123456`
