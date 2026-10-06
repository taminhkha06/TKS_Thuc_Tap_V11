using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.BC
{
	public class CBC_Bao_Cao_Xuat_Nhap_Ton
	{
		public string Ma_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public decimal SL_Dau_Ky { get; set; }
		public decimal SL_Nhap { get; set; }
		public decimal SL_Xuat { get; set; }
		public decimal SL_Cuoi_Ky { get; set; }
	}
}
