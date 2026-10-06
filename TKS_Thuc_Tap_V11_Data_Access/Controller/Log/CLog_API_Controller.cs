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
    public class CLog_API_Controller
    {
        public List<CLog_API> FQ_401_A_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_API> v_arrRes = new List<CLog_API>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_401_A_sp_sel_List_By_Created", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_API v_objRes = CUtility.Map_Row_To_Entity<CLog_API>(v_row);
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

        public List<CLog_API> FQ_401_A_sp_sel_List_For_Cache()
        {
            List<CLog_API> v_arrRes = new List<CLog_API>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_401_A_sp_sel_List_For_Cache");

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_API v_objRes = CUtility.Map_Row_To_Entity<CLog_API>(v_row);
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

        public CLog_API FQ_401_A_sp_sel_Get_By_ID(long p_iID)
        {
            CLog_API v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_401_A_sp_sel_Get_By_ID", p_iID);

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CLog_API>(v_dt.Rows[0]);
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

            return v_objRes;
        }

        public long FCommon_Insert_Log_API(CLog_API p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FCommon_Insert_Log_API",
                    p_objData.Key_No, p_objData.API_Source_Name, p_objData.API_Function_Name, p_objData.Description,
                    p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public long FCommon_Insert_Log_API(SqlConnection p_conn, SqlTransaction p_trans, CLog_API p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FCommon_Insert_Log_API",
                    p_objData.Key_No, p_objData.API_Source_Name, p_objData.API_Function_Name, p_objData.Description,
                    p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public void F1041_1_sp_upd_Log_API_Trang_Thai_ID(SqlConnection p_conn, SqlTransaction p_trans, CLog_API p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "F1041_1_sp_upd_Log_API_Trang_Thai_ID",
                    p_objData.Auto_ID, p_objData.Trang_Thai_ID, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void F1041_1_sp_upd_Log_API_Trang_Thai_ID(CLog_API p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "F1041_1_sp_upd_Log_API_Trang_Thai_ID",
                    p_objData.Auto_ID, p_objData.Trang_Thai_ID, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
