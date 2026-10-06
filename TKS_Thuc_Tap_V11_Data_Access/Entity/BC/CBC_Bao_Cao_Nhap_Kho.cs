using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.BC
{
	public class CBC_Bao_Cao_Nhap_Kho
	{
		public DateTime? Ngay_Nhap_Kho { get; set; }
		public string So_Phieu_Nhap_Kho { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_NCC { get; set; } = CConst.STR_VALUE_NULL;
		public string Ma_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public decimal SL_Nhap { get; set; }
		public decimal Don_Gia_Nhap { get; set; }
		public decimal Tri_Gia { get; set; }
	}
}
