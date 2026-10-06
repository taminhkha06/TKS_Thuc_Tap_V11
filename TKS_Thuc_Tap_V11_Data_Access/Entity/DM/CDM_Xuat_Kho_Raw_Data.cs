using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.DM
{
	public class CDM_Xuat_Kho_Raw_Data
	{
		public long Auto_ID { get; set; }
		public long Xuat_Kho_ID { get; set; }
		public long San_Pham_ID { get; set; }
		public decimal SL_Xuat { get; set; }
		public decimal Don_Gia_Xuat { get; set; }
		public string Ma_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_San_Pham { get; set; } = CConst.STR_VALUE_NULL;
		public string Ten_Don_Vi_Tinh { get; set; } = CConst.STR_VALUE_NULL;
        public int deleted { get; set; }
        public DateTime? Created { get; set; }
        public string Created_By { get; set; } = CConst.STR_VALUE_NULL;
        public string Created_By_Function { get; set; } = CConst.STR_VALUE_NULL;
        public DateTime? Last_Updated { get; set; }
        public string Last_Updated_By { get; set; } = CConst.STR_VALUE_NULL;
        public string Last_Updated_By_Function { get; set; } = CConst.STR_VALUE_NULL;
    }
}
