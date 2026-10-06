using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Report_File_Excel
    {
        private long m_lngAuto_ID;
        private long m_lngChu_Hang_ID;
        private string m_strMa_Chu_Hang;
        private long m_lngKho_ID;
        private string m_strMa_Kho;
        private string m_strTen_File;
        private string m_strFile_URL;
        private int m_intReport_File_Type_ID;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_Report_File_Excel()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_lngChu_Hang_ID = CConst.INT_VALUE_NULL;
            m_strMa_Chu_Hang = CConst.STR_VALUE_NULL;
            m_lngKho_ID = CConst.INT_VALUE_NULL;
            m_strMa_Kho = CConst.STR_VALUE_NULL;
            m_strTen_File = CConst.STR_VALUE_NULL;
            m_strFile_URL = CConst.STR_VALUE_NULL;
            m_intReport_File_Type_ID = CConst.INT_VALUE_NULL;
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

        public long Chu_Hang_ID
        {
            get => m_lngChu_Hang_ID;
            set => m_lngChu_Hang_ID = value;
        }

        public string Ma_Chu_Hang
        {
            get => m_strMa_Chu_Hang;
            set => m_strMa_Chu_Hang = value != null ? value.Trim() : "";
        }

        public long Kho_ID
        {
            get => m_lngKho_ID;
            set => m_lngKho_ID = value;
        }

        public string Ma_Kho
        {
            get => m_strMa_Kho;
            set => m_strMa_Kho = value != null ? value.Trim() : "";
        }

        public string Ten_File
        {
            get => m_strTen_File;
            set => m_strTen_File = value != null ? value.Trim() : "";
        }

        public string File_URL
        {
            get => m_strFile_URL;
            set => m_strFile_URL = value != null ? value.Trim() : "";
        }

        public int Report_File_Type_ID
        {
            get => m_intReport_File_Type_ID;
            set => m_intReport_File_Type_ID = value;
        }

        public string Report_File_Type_Text
        {
            get
            {
                switch (m_intReport_File_Type_ID)
                {
                    case (int)EReport_File_Type_ID.Export_Excel:
                        return "Export Excel";
                    default:
                        return ((EReport_File_Type_ID)m_intReport_File_Type_ID).ToString();
                }
            }
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
    }
}
