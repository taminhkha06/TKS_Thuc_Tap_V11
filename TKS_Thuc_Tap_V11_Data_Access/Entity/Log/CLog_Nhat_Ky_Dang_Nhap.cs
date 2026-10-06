using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Nhat_Ky_Dang_Nhap
    {
        private long m_lngAuto_ID;
        private string m_strMa_Dang_Nhap;
        private string m_strIP;
        private string m_strUser_Agent;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_Nhat_Ky_Dang_Nhap()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strMa_Dang_Nhap = CConst.STR_VALUE_NULL;
            m_strIP = CConst.STR_VALUE_NULL;
            m_strUser_Agent = CConst.STR_VALUE_NULL;
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

        public string Ma_Dang_Nhap
        {
            get => m_strMa_Dang_Nhap;
            set => m_strMa_Dang_Nhap = value != null ? value.Trim() : "";
        }

        public string IP
        {
            get => m_strIP;
            set => m_strIP = value != null ? value.Trim() : "";
        }

        public string User_Agent
        {
            get => m_strUser_Agent;
            set => m_strUser_Agent = value != null ? value.Trim() : "";
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
