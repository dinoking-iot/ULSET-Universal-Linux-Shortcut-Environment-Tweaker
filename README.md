# 🖱️ Universal Linux Shortcut Environment Tweaker (ULSET) 🚀

> **Bring Windows-style "Send to Desktop (Create Shortcut)" with automatic `.exe` icon extraction to BigLinux & KDE/Linux — without touching your stock Wine setup.**  
> *Mang tính năng chuột phải "Send to Desktop (Tạo Shortcut)" kèm tự động trích xuất icon file `.exe` chuẩn như Windows lên BigLinux & KDE/Linux — giữ nguyên vẹn cấu hình Wine gốc của bạn.*


---

### 🔥 Overview / Tổng quan

**ULSET** is a lightweight, silent cross-platform context menu engine designed specifically for **BigLinux** (and Arch, Debian, Ubuntu, Mint, Fedora, Zorin, Deepin) users who miss the effortless workflow of creating desktop shortcuts on Windows.  
***ULSET** là công cụ tích hợp menu chuột phải gọn nhẹ, hoạt động âm thầm dành riêng cho người dùng **BigLinux** (cùng Arch, Debian, Ubuntu, Mint, Fedora, Zorin, Deepin) muốn giữ thói quen tạo shortcut ngoài màn hình Desktop nhanh gọn như trên Windows.*

Unlike heavy third-party wrappers, ULSET preserves your **stock Wine** environment while automatically extracting high-res icons from Windows `.exe` binaries and matching native icons for documents, images, and media.  
*Khác với các trình quản lý cồng kềnh, ULSET bảo toàn nguyên vẹn môi trường **Wine gốc**, đồng thời tự động trích xuất icon sắc nét từ file `.exe` của Windows và gán đúng biểu tượng hệ thống cho các file tài liệu, hình ảnh.*

---

### ✨ Key Features / Tính năng nổi bật

* 🖱️ **One-Click "Send to Desktop" / Chuột phải "Gửi ra Desktop":**  
  Adds a top-level **`Send to Desktop (Create Shortcut)` / `Gửi ra Desktop (Tạo Shortcut)`** action directly inside the KDE Dolphin right-click menu for any file type (`MimeType=all/all`).  
  *Thêm trực tiếp tùy chọn **`Send to Desktop (Create Shortcut)` / `Gửi ra Desktop (Tạo Shortcut)`** ngay trên menu chuột phải của trình quản lý file Dolphin cho mọi định dạng tệp.*

* 🎨 **Smart `.exe` Icon Extractor / Tự động trích xuất Icon từ file `.exe`:**  
  Automatically uses `wrestool` & `icotool` (`icoutils`) to extract embedded icons from Windows `.exe` files into `~/.local/share/icons/` and binds them to `wine` execution paths.  
  *Tự động dùng `wrestool` & `icotool` (`icoutils`) để tách icon gốc bên trong file `.exe` của Windows lưu vào `~/.local/share/icons/` và gắn thẳng lệnh chạy qua `wine`.*

* 📄 **Universal File Type Support / Hỗ trợ mọi định dạng tài liệu & media:**  
  Smartly assigns native XDG icons (`x-office-document`, `application-pdf`, `image-x-generic`, etc.) and binds `xdg-open` for `.docx`, `.xlsx`, `.pptx`, `.pdf`, `.jpg`, `.png`, and `.txt` files.  
  *Tự động nhận diện và gán biểu tượng chuẩn (`x-office-document`, `application-pdf`, `image-x-generic`...) kèm lệnh mở mặc định `xdg-open` cho các file `.docx`, `.xlsx`, `.pptx`, `.pdf`, `.jpg`, `.png`, `.txt`.*

* 🛡️ **100% Stock Wine Preservation / Bảo toàn nguyên vẹn Wine gốc:**  
  Never forces unwanted Wine upgrades, removals, or prefix overwrites—only installs `wine` and `icoutils` silently if completely missing.  
  *Tuyệt đối không ép nâng cấp, gỡ bỏ hay ghi đè prefix Wine hiện có — chỉ âm thầm cài đặt `wine` và `icoutils` nếu máy chưa có.*

* 🎛️ **Bilingual Anti-Conflict Control Panel / Bảng điều khiển song ngữ chống xung đột:**  
  Features an interactive terminal UI (auto-spawns `konsole`, `qterminal`, `gnome-terminal`, or `xterm` when double-clicked) with smart state locking to prevent duplicate installations, plus a clean 1-click removal option.  
  *Tích hợp giao diện điều khiển song ngữ trực quan (tự động mở `konsole`, `qterminal`, `gnome-terminal` hoặc `xterm` khi nhấp đúp), khóa trạng thái thông minh tránh cài trùng lặp và hỗ trợ gỡ bỏ sạch sẽ chỉ với 1 phím bấm.*

* 📊 **Background Diagnostic Daemon / Tiến trình ngầm theo dõi gỡ lỗi:**  
  Includes a lightweight background logger (`ulset_shortcut_daemon`) and structured JSON patch tracking under `~/Documents/ULSET_Logs/`.  
  *Đi kèm tiến trình ngầm ghi nhật ký (`ulset_shortcut_daemon`) và lịch sử bản vá JSON lưu tại `~/Documents/ULSET_Logs/` giúp dễ dàng kiểm tra khi cần.*

---

### 🚀 How to Use / Hướng dẫn sử dụng

```bash
# 1. Make the script executable / Cấp quyền thực thi cho script
chmod +x ulset.sh

# 2. Launch the interactive control panel (or simply double-click it!)
# Mở bảng điều khiển tương tác (hoặc đơn giản là nhấp đúp vào file!)
./ulset.sh
```

* Press **`1`** to install & activate **"Send to Desktop (Create Shortcut)"** (Dolphin restarts automatically to apply).  
  *Nhấn phím **`1`** để cài đặt & kích hoạt **"Gửi ra Desktop (Tạo Shortcut)"** (Dolphin sẽ tự làm mới để áp dụng ngay).*
* Press **`2`** to cleanly remove the context menu without affecting Wine or existing shortcuts.  
  *Nhấn phím **`2`** để gỡ bỏ sạch sẽ menu chuột phải mà không làm ảnh hưởng đến Wine hay các shortcut đã tạo.*

  Download  https://github.com/dinoking-iot/ULSET-Universal-Linux-Shortcut-Environment-Tweaker/releases/tag/ULSETv1
  
