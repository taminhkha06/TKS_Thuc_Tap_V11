using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Record_Action_History
    {
        private long m_lngAuto_ID;
        private long m_lngRef_ID;
        private string m_strTen_Hanh_Dong;
        private string m_strTen_Moi_Truong;
        private string m_strMa_Chuc_Nang;
        private string m_strTen_Chuc_Nang;
        private string m_strNoi_Dung_Action;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_Record_Action_History()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_lngRef_ID = CConst.INT_VALUE_NULL;
            m_strTen_Hanh_Dong = CConst.STR_VALUE_NULL;
            m_strTen_Moi_Truong = CConst.STR_VALUE_NULL;
            m_strMa_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_strTen_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_strNoi_Dung_Action = CConst.STR_VALUE_NULL;
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

        public long Ref_ID
        {
            get => m_lngRef_ID;
            set => m_lngRef_ID = value;
        }

        public string Ref_Text
        {
            get => m_lngRef_ID.ToString();
        }

        public string Ten_Hanh_Dong
        {
            get => m_strTen_Hanh_Dong;
            set => m_strTen_Hanh_Dong = value != null ? value.Trim() : "";
        }

        public string Ten_Moi_Truong
        {
            get => m_strTen_Moi_Truong;
            set => m_strTen_Moi_Truong = value != null ? value.Trim() : "";
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

        public string Noi_Dung_Action
        {
            get => m_strNoi_Dung_Action;
            set => m_strNoi_Dung_Action = value != null ? value.Trim() : "";
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
