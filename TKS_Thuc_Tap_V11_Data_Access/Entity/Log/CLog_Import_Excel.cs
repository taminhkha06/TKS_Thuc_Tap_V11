using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Import_Excel
    {
        private long m_lngAuto_ID;
        private string m_strMa_Chuc_Nang;
        private string m_strTen_Chuc_Nang;
        private string m_strLink_URL;
        private int m_intTrang_Thai_ID;
        private string m_strGhi_Chu;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_Import_Excel()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strMa_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_strTen_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_strLink_URL = CConst.STR_VALUE_NULL;
            m_intTrang_Thai_ID = CConst.INT_VALUE_NULL;
            m_strGhi_Chu = CConst.STR_VALUE_NULL;
            m_intdeleted = CConst.INT_VALUE_NULL;
            m_dtmCreated = CConst.DTM_VALUE_NULL;
            m_strCreated_By = CConst.STR_VALUE_NULL;
            m_strCreated_By_Function = CConst.STR_VALUE_NULL;
            m_dtmLast_Updated = CConst.DTM_VALUE_NULL;
            m_strLast_Updated_By = CConst.STR_VALUE_NULL;
            m_strLast_Updated_By_Function = CConst.STR_VALUE_NULL;
        }

        public long Auto_ID
        {
            get => m_lngAuto_ID;
            set => m_lngAuto_ID = value;
        }

        public string Ma_Chuc_Nang
        {
            get => m_strMa_Chuc_Nang;
            set => m_strMa_Chuc_Nang = value != null ? value.Trim() : "";
        }

        public string Ten_Chuc_Nang
        {
            get => m_strTen_Chuc_Nang;
            set => m_strTen_Chuc_Nang = value != null ? value.Trim() : "";
        }

        public string Link_URL
        {
            get => m_strLink_URL;
            set => m_strLink_URL = value != null ? value.Trim() : "";
        }

        public int Trang_Thai_ID
        {
            get => m_intTrang_Thai_ID;
            set => m_intTrang_Thai_ID = value;
        }

        public string Ghi_Chu
        {
            get => m_strGhi_Chu;
            set => m_strGhi_Chu = value != null ? value.Trim() : "";
        }

        public int deleted
        {
            get => m_intdeleted;
            set => m_intdeleted = value;
        }

        public DateTime? Created
        {
            get => m_dtmCreated;
            set => m_dtmCreated = value;
        }

        public string Created_By
        {
            get => m_strCreated_By;
            set => m_strCreated_By = value != null ? value.Trim() : "";
        }

        public string Created_By_Function
        {
            get => m_strCreated_By_Function;
            set => m_strCreated_By_Function = value != null ? value.Trim() : "";
        }

        public DateTime? Last_Updated
        {
            get => m_dtmLast_Updated;
            set => m_dtmLast_Updated = value;
        }

        public string Last_Updated_By
        {
            get => m_strLast_Updated_By;
            set => m_strLast_Updated_By = value != null ? value.Trim() : "";
        }

        public string Last_Updated_By_Function
        {
            get => m_strLast_Updated_By_Function;
            set => m_strLast_Updated_By_Function = value != null ? value.Trim() : "";
        }

        public string Trang_Thai_HTML
        {
            get
            {
                switch (m_intTrang_Thai_ID)
                {
                    case (int)ETrang_Thai_Import_Excel_ID.Thanh_Cong:
                        return "<span class=\"badge bg-success\">Thành công</span>";
                    case (int)ETrang_Thai_Import_Excel_ID.Thanh_Cong_1_Phan:
                        return "<span class=\"badge bg-warning\">Thành công 1 phần</span>";
                    case (int)ETrang_Thai_Import_Excel_ID.That_Bai:
                        return "<span class=\"badge bg-danger\">Thất bại</span>";
                    default:
                        return $"<span class=\"badge bg-secondary\">{m_intTrang_Thai_ID}</span>";
                }
            }
        }
    }
}
