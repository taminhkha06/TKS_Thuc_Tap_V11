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
    public class CLog_Nhat_Ky_Dang_Nhap_Controller
    {
        public long FQ_423_NKDN_sp_ins_Insert(CLog_Nhat_Ky_Dang_Nhap p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_ins_Insert",
                    p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public long FQ_423_NKDN_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CLog_Nhat_Ky_Dang_Nhap p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                object v_objVal = CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_ins_Insert",
                    p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);

                if (v_objVal != null && v_objVal != DBNull.Value)
                    v_iRes = Convert.ToInt64(v_objVal);
            }
            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public List<CLog_Nhat_Ky_Dang_Nhap> F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan(DateTime? p_dtmFrom, DateTime? p_dtmTo, string p_strMa_Dang_Nhap)
        {
            List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan", p_dtmFrom, p_dtmTo, p_strMa_Dang_Nhap);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
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

        public List<CLog_Nhat_Ky_Dang_Nhap> F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
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

        public List<CLog_Nhat_Ky_Dang_Nhap> F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User(string p_strMa_Dang_Nhap)
        {
            List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User", p_strMa_Dang_Nhap);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
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
    }
}
