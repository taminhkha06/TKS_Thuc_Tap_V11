using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_API
    {
        private long m_lngAuto_ID;
        private string m_strKey_No;
        private string m_strAPI_Source_Name;
        private string m_strAPI_Function_Name;
        private string m_strDescription;
        private string m_strLink_URL;
        private int m_intTrang_Thai_ID;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_API()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strKey_No = CConst.STR_VALUE_NULL;
            m_strAPI_Source_Name = CConst.STR_VALUE_NULL;
            m_strAPI_Function_Name = CConst.STR_VALUE_NULL;
            m_strDescription = CConst.STR_VALUE_NULL;
            m_strLink_URL = CConst.STR_VALUE_NULL;
            m_intTrang_Thai_ID = CConst.INT_VALUE_NULL;
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

        public string Key_No
        {
            get => m_strKey_No;
            set => m_strKey_No = value != null ? value.Trim() : "";
        }

        public string API_Source_Name
        {
            get => m_strAPI_Source_Name;
            set => m_strAPI_Source_Name = value != null ? value.Trim() : "";
        }

        public string API_Function_Name
        {
            get => m_strAPI_Function_Name;
            set => m_strAPI_Function_Name = value != null ? value.Trim() : "";
        }

        public string Description
        {
            get => m_strDescription;
            set => m_strDescription = value != null ? value.Trim() : "";
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

        public string Key_All
        {
            get => CUtility.Tao_Key(m_strKey_No, m_strAPI_Source_Name, m_strAPI_Function_Name);
        }

        public string Trang_Thai_Text
        {
            get
            {
                switch (m_intTrang_Thai_ID)
                {
                    case (int)ECommon_Status_ID.Available: return "Available";
                    case (int)ECommon_Status_ID.Completed: return "Completed";
                    case (int)ECommon_Status_ID.Close: return "Close";
                    case (int)ECommon_Status_ID.Not_Confirm: return "Not_Confirm";
                    case (int)ECommon_Status_ID.Confirmed: return "Confirmed";
                    case (int)ECommon_Status_ID.Is_Running: return "Is_Running";
                    case (int)ECommon_Status_ID.Error: return "Error";
                    default: return ((ECommon_Status_ID)m_intTrang_Thai_ID).ToString();
                }
            }
        }

        public string Trang_Thai_HTML
        {
            get
            {
                switch (m_intTrang_Thai_ID)
                {
                    case (int)ECommon_Status_ID.Available: return "<span class=\"badge bg-success\">Available</span>";
                    case (int)ECommon_Status_ID.Completed: return "<span class=\"badge bg-success\">Completed</span>";
                    case (int)ECommon_Status_ID.Close: return "<span class=\"badge bg-secondary\">Close</span>";
                    case (int)ECommon_Status_ID.Not_Confirm: return "<span class=\"badge bg-warning\">Not Confirm</span>";
                    case (int)ECommon_Status_ID.Confirmed: return "<span class=\"badge bg-info\">Confirmed</span>";
                    case (int)ECommon_Status_ID.Is_Running: return "<span class=\"badge bg-primary\">Is Running</span>";
                    case (int)ECommon_Status_ID.Error: return "<span class=\"badge bg-danger\">Error</span>";
                    default: return $"<span class=\"badge bg-secondary\">{m_intTrang_Thai_ID}</span>";
                }
            }
        }
    }
}
