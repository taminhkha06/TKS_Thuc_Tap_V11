using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Log;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Log
{
    public class CLog_Import_Excel_Controller
    {
        public List<CLog_Import_Excel> F1029_sp_sel_List_Nhat_Ky_Import_Excel(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_Import_Excel> v_arrRes = new List<CLog_Import_Excel>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1029_sp_sel_List_Nhat_Ky_Import_Excel", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Import_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_row);
                    v_arrRes.Add(v_objRes);
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                v_dt.Dispose();
            }

            return v_arrRes;
        }

        public long FQ_422_IE_sp_ins_Insert(CLog_Import_Excel p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_ins_Insert",
                    p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL,
                    p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public long FQ_422_IE_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CLog_Import_Excel p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_ins_Insert",
                    p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL,
                    p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }
    }
}
