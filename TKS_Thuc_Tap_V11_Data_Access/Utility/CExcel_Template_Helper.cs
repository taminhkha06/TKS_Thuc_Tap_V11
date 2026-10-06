using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.IO;

namespace TKS_Thuc_Tap_V11_Data_Access.Utility
{
    public static class CExcel_Template_Helper
    {
        public static void Ensure_All_Templates_Exist(string p_strTemplate_Folder)
        {
            if (string.IsNullOrWhiteSpace(p_strTemplate_Folder))
                return;

            if (!Directory.Exists(p_strTemplate_Folder))
                Directory.CreateDirectory(p_strTemplate_Folder);

            ExcelPackage.License.SetNonCommercialOrganization("Công Ty Cổ Phần Logistics WMS");

            Create_Don_Vi_Tinh_Template(Path.Combine(p_strTemplate_Folder, "Don_Vi_Tinh_Template.xlsx"));
            Create_Loai_San_Pham_Template(Path.Combine(p_strTemplate_Folder, "Loai_San_Pham_Template.xlsx"));
            Create_Nha_Cung_Cap_Template(Path.Combine(p_strTemplate_Folder, "Nha_Cung_Cap_Template.xlsx"));
            Create_Kho_Template(Path.Combine(p_strTemplate_Folder, "Kho_Template.xlsx"));
            Create_San_Pham_Template(Path.Combine(p_strTemplate_Folder, "San_Pham_Template.xlsx"));
        }

        private static void Style_Header(ExcelRange p_range)
        {
            p_range.Style.Font.Bold = true;
            p_range.Style.Font.Color.SetColor(Color.White);
            p_range.Style.Fill.PatternType = ExcelFillStyle.Solid;
            p_range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(51, 102, 204));
            p_range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            p_range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
        }

        private static void Create_Don_Vi_Tinh_Template(string p_strFilePath)
        {
            if (File.Exists(p_strFilePath))
                return;

            using (var package = new ExcelPackage())
            {
                var ws = package.Workbook.Worksheets.Add("Don_Vi_Tinh");
                ws.Cells[1, 1].Value = "Tên đơn vị tính";
                ws.Cells[1, 2].Value = "Ghi chú";
                Style_Header(ws.Cells["A1:B1"]);

                ws.Cells[2, 1].Value = "Cái";
                ws.Cells[2, 2].Value = "Đơn vị tính cơ bản";

                ws.Cells[3, 1].Value = "Hộp";
                ws.Cells[3, 2].Value = "Hộp 10 cái";

                ws.Cells[4, 1].Value = "Thùng";
                ws.Cells[4, 2].Value = "Thùng 24 lon / hộp";

                ws.Cells.AutoFitColumns();
                package.SaveAs(new FileInfo(p_strFilePath));
            }
        }

        private static void Create_Loai_San_Pham_Template(string p_strFilePath)
        {
            if (File.Exists(p_strFilePath))
                return;

            using (var package = new ExcelPackage())
            {
                var ws = package.Workbook.Worksheets.Add("Loai_San_Pham");
                ws.Cells[1, 1].Value = "Mã loại sản phẩm";
                ws.Cells[1, 2].Value = "Tên loại sản phẩm";
                ws.Cells[1, 3].Value = "Ghi chú";
                Style_Header(ws.Cells["A1:C1"]);

                ws.Cells[2, 1].Value = "LSP01";
                ws.Cells[2, 2].Value = "Điện tử";
                ws.Cells[2, 3].Value = "Hàng linh kiện và thiết bị điện tử";

                ws.Cells[3, 1].Value = "LSP02";
                ws.Cells[3, 2].Value = "Gia dụng";
                ws.Cells[3, 3].Value = "Hàng gia dụng thông minh";

                ws.Cells.AutoFitColumns();
                package.SaveAs(new FileInfo(p_strFilePath));
            }
        }

        private static void Create_Nha_Cung_Cap_Template(string p_strFilePath)
        {
            if (File.Exists(p_strFilePath))
                return;

            using (var package = new ExcelPackage())
            {
                var ws = package.Workbook.Worksheets.Add("Nha_Cung_Cap");
                ws.Cells[1, 1].Value = "Mã nhà cung cấp";
                ws.Cells[1, 2].Value = "Tên nhà cung cấp";
                ws.Cells[1, 3].Value = "Ghi chú";
                Style_Header(ws.Cells["A1:C1"]);

                ws.Cells[2, 1].Value = "NCC01";
                ws.Cells[2, 2].Value = "Công ty TNHH Thiết Bị Số";
                ws.Cells[2, 3].Value = "Nhà cung cấp chính linh kiện";

                ws.Cells[3, 1].Value = "NCC02";
                ws.Cells[3, 2].Value = "Công ty Cổ Phần Phân Phối Toàn Cầu";
                ws.Cells[3, 3].Value = "Nhà cung cấp phụ kiện";

                ws.Cells.AutoFitColumns();
                package.SaveAs(new FileInfo(p_strFilePath));
            }
        }

        private static void Create_Kho_Template(string p_strFilePath)
        {
            if (File.Exists(p_strFilePath))
                return;

            using (var package = new ExcelPackage())
            {
                var ws = package.Workbook.Worksheets.Add("Kho");
                ws.Cells[1, 1].Value = "Tên kho";
                ws.Cells[1, 2].Value = "Ghi chú";
                Style_Header(ws.Cells["A1:B1"]);

                ws.Cells[2, 1].Value = "Kho Tổng Hồ Chí Minh";
                ws.Cells[2, 2].Value = "Kho trung tâm khu vực miền Nam";

                ws.Cells[3, 1].Value = "Kho Hà Nội";
                ws.Cells[3, 2].Value = "Kho trung chuyển khu vực miền Bắc";

                ws.Cells.AutoFitColumns();
                package.SaveAs(new FileInfo(p_strFilePath));
            }
        }

        private static void Create_San_Pham_Template(string p_strFilePath)
        {
            if (File.Exists(p_strFilePath))
                return;

            using (var package = new ExcelPackage())
            {
                var ws = package.Workbook.Worksheets.Add("San_Pham");
                ws.Cells[1, 1].Value = "Mã sản phẩm";
                ws.Cells[1, 2].Value = "Tên sản phẩm";
                ws.Cells[1, 3].Value = "Loại sản phẩm (Mã hoặc Tên)";
                ws.Cells[1, 4].Value = "Đơn vị tính";
                ws.Cells[1, 5].Value = "Ghi chú";
                Style_Header(ws.Cells["A1:E1"]);

                ws.Cells[2, 1].Value = "SP001";
                ws.Cells[2, 2].Value = "Màn hình vi tính 24 inch";
                ws.Cells[2, 3].Value = "LSP01";
                ws.Cells[2, 4].Value = "Cái";
                ws.Cells[2, 5].Value = "Màn hình IPS Full HD";

                ws.Cells[3, 1].Value = "SP002";
                ws.Cells[3, 2].Value = "Bàn phím cơ Bluetooth";
                ws.Cells[3, 3].Value = "Điện tử";
                ws.Cells[3, 4].Value = "Cái";
                ws.Cells[3, 5].Value = "Bàn phím không dây kết nối đa thiết bị";

                ws.Cells.AutoFitColumns();
                package.SaveAs(new FileInfo(p_strFilePath));
            }
        }
    }
}
