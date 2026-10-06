using System;
using System.Collections.Generic;
using System.Data;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.BC;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.BC
{
	public class CBC_Bao_Cao_Controller
	{
		public List<CBC_Bao_Cao_Nhap_Kho> FQ_2015_BC_sp_sel_Bao_Cao_Nhap_Kho(DateTime? p_dtmNgay_Dau_Ky, DateTime? p_dtmNgay_Cuoi_Ky)
		{
			List<CBC_Bao_Cao_Nhap_Kho> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_2015_BC_sp_sel_Bao_Cao_Nhap_Kho", p_dtmNgay_Dau_Ky, p_dtmNgay_Cuoi_Ky);
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CBC_Bao_Cao_Nhap_Kho>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}

		public List<CBC_Bao_Cao_Xuat_Kho> FQ_2016_BC_sp_sel_Bao_Cao_Xuat_Kho(DateTime? p_dtmNgay_Dau_Ky, DateTime? p_dtmNgay_Cuoi_Ky)
		{
			List<CBC_Bao_Cao_Xuat_Kho> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_2016_BC_sp_sel_Bao_Cao_Xuat_Kho", p_dtmNgay_Dau_Ky, p_dtmNgay_Cuoi_Ky);
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CBC_Bao_Cao_Xuat_Kho>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}

		public List<CBC_Bao_Cao_Xuat_Nhap_Ton> FQ_2017_BC_sp_sel_Bao_Cao_Xuat_Nhap_Ton(DateTime? p_dtmNgay_Dau_Ky, DateTime? p_dtmNgay_Cuoi_Ky)
		{
			List<CBC_Bao_Cao_Xuat_Nhap_Ton> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_2017_BC_sp_sel_Bao_Cao_Xuat_Nhap_Ton", p_dtmNgay_Dau_Ky, p_dtmNgay_Cuoi_Ky);
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CBC_Bao_Cao_Xuat_Nhap_Ton>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}
	}
}
