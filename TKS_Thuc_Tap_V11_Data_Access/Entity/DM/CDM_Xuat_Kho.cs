using System;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.DM
{
	public class CDM_Xuat_Kho
	{
		public long Auto_ID { get; set; }
		public string So_Phieu_Xuat_Kho { get; set; } = CConst.STR_VALUE_NULL;
		public long Kho_ID { get; set; }
		public DateTime? Ngay_Xuat_Kho { get; set; } = DateTime.Today;
		public string Ghi_Chu { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_Kho { get; set; } = CConst.STR_VALUE_NULL;
		public int So_Dong_Hang { get; set; }
		public decimal Tong_Tien { get; set; }
		public int deleted { get; set; }
		public DateTime? Created { get; set; }
		public string Created_By { get; set; } = CConst.STR_VALUE_NULL;
		public string Created_By_Function { get; set; } = CConst.STR_VALUE_NULL;
		public DateTime? Last_Updated { get; set; }
		public string Last_Updated_By { get; set; } = CConst.STR_VALUE_NULL;
		public string Last_Updated_By_Function { get; set; } = CConst.STR_VALUE_NULL;
	}
}
