using System;
using System.Collections.Generic;
using System.Data;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

using Microsoft.Data.SqlClient;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.DM
{
	public class CDM_Nha_Cung_Cap_Controller
	{
		public List<CDM_Nha_Cung_Cap> FQ_108_NCC_sp_sel_List()
		{
			List<CDM_Nha_Cung_Cap> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_108_NCC_sp_sel_List");
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CDM_Nha_Cung_Cap>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}

		public CDM_Nha_Cung_Cap FQ_108_NCC_sp_sel_Get_By_ID(long p_iID)
		{
			CDM_Nha_Cung_Cap v_objRes = null;
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_108_NCC_sp_sel_Get_By_ID", p_iID);
				if (v_dt.Rows.Count > 0)
					v_objRes = CUtility.Map_Row_To_Entity<CDM_Nha_Cung_Cap>(v_dt.Rows[0]);
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_objRes;
		}

		public long FQ_108_NCC_sp_ins_Insert(CDM_Nha_Cung_Cap p_objData)
		{
			return Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_108_NCC_sp_ins_Insert",
				p_objData.Ma_NCC, p_objData.Ten_NCC, p_objData.Ghi_Chu,
				p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
		}

		public long FQ_108_NCC_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CDM_Nha_Cung_Cap p_objData)
		{
			return Convert.ToInt64(CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_108_NCC_sp_ins_Insert",
				p_objData.Ma_NCC, p_objData.Ten_NCC, p_objData.Ghi_Chu,
				p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
		}

		public void FQ_108_NCC_sp_upd_Update(CDM_Nha_Cung_Cap p_objData)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_108_NCC_sp_upd_Update", p_objData.Auto_ID,
				p_objData.Ma_NCC, p_objData.Ten_NCC, p_objData.Ghi_Chu,
				p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
		}

		public void FQ_108_NCC_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_108_NCC_sp_del_Delete_By_ID",
				p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
		}
	}
}