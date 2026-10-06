using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using OfficeOpenXml;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.DM
{
	public class CDM_Nhap_Kho_Controller
	{
		public CDM_Nhap_Kho FQ_111_NK_sp_sel_Get_By_ID(long p_iID)
		{
			return FQ_111_NK_sp_sel_List().FirstOrDefault(v_objData => v_objData.Auto_ID == p_iID);
		}

		public List<CDM_Nhap_Kho> FQ_111_NK_sp_sel_List()
		{
			List<CDM_Nhap_Kho> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_111_NK_sp_sel_List");
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CDM_Nhap_Kho>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}

		public List<CDM_Nhap_Kho_Raw_Data> FQ_111_NK_sp_sel_List_Raw_By_Nhap_Kho_ID(long p_iNhap_Kho_ID)
		{
			List<CDM_Nhap_Kho_Raw_Data> v_arrRes = new();
			DataTable v_dt = new();
			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_111_NK_sp_sel_List_Raw_By_Nhap_Kho_ID", p_iNhap_Kho_ID);
				foreach (DataRow v_row in v_dt.Rows)
					v_arrRes.Add(CUtility.Map_Row_To_Entity<CDM_Nhap_Kho_Raw_Data>(v_row));
			}
			finally
			{
				v_dt.Dispose();
			}
			return v_arrRes;
		}

		public long FQ_111_NK_sp_ins_Insert_With_Raw_Data(CDM_Nhap_Kho p_objData, List<CDM_Nhap_Kho_Raw_Data> p_arrRaw_Data)
		{
			if (p_arrRaw_Data == null || p_arrRaw_Data.Count == 0)
				throw new InvalidOperationException("Phiếu nhập phải có ít nhất một dòng sản phẩm.");

			using SqlConnection v_conn = CSqlHelper.CreateConnection(CConfig.TKS_Thuc_Tap_V11_Conn_String);
			v_conn.Open();
			using SqlTransaction v_trans = v_conn.BeginTransaction();
			try
			{
				long v_iNhap_Kho_ID = Convert.ToInt64(CSqlHelper.ExecuteScalar(v_conn, v_trans,
					CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_ins_Insert",
					p_objData.So_Phieu_Nhap_Kho, p_objData.Kho_ID, p_objData.NCC_ID,
					p_objData.Ngay_Nhap_Kho, p_objData.Ghi_Chu,
					p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));

				foreach (CDM_Nhap_Kho_Raw_Data v_objRaw in p_arrRaw_Data)
				{
					CSqlHelper.ExecuteNonquery(v_conn, v_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String,
						"FQ_111_NK_sp_ins_Insert_Raw_Data", v_iNhap_Kho_ID, v_objRaw.San_Pham_ID,
						v_objRaw.SL_Nhap, v_objRaw.Don_Gia_Nhap);
				}

				v_trans.Commit();
				return v_iNhap_Kho_ID;
			}
			catch
			{
				v_trans.Rollback();
				throw;
			}
		}

		public void FQ_111_NK_sp_ins_Insert_Raw_Data(long p_iNhap_Kho_ID, CDM_Nhap_Kho_Raw_Data p_objRaw_Data)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_ins_Insert_Raw_Data",
				p_iNhap_Kho_ID, p_objRaw_Data.San_Pham_ID, p_objRaw_Data.SL_Nhap, p_objRaw_Data.Don_Gia_Nhap);
		}

		public void FQ_111_NK_sp_upd_Update_Raw_Data(CDM_Nhap_Kho_Raw_Data p_objRaw_Data)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_upd_Update_Raw_Data",
				p_objRaw_Data.Auto_ID, p_objRaw_Data.SL_Nhap, p_objRaw_Data.Don_Gia_Nhap);
		}

		public void FQ_111_NK_sp_del_Delete_Raw_Data(long p_iRaw_Data_ID)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_del_Delete_Raw_Data", p_iRaw_Data_ID);
		}

		public void FQ_111_NK_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_del_Delete_By_ID",
				p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
		}

		public void FQ_111_NK_sp_upd_Update_Header(CDM_Nhap_Kho p_objData)
		{
			CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_111_NK_sp_upd_Update_Header",
				p_objData.Auto_ID, p_objData.So_Phieu_Nhap_Kho, p_objData.Kho_ID, p_objData.NCC_ID,
				p_objData.Ngay_Nhap_Kho, p_objData.Ghi_Chu,
				p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
		}

		public byte[] FQ_111_NK_rpt_Generate_Print_Template(long p_iNhap_Kho_ID, string p_strTemplate_Path)
		{
			CDM_Nhap_Kho v_objHeader = FQ_111_NK_sp_sel_Get_By_ID(p_iNhap_Kho_ID)
				?? throw new InvalidOperationException("Không tìm thấy phiếu nhập kho.");
			List<CDM_Nhap_Kho_Raw_Data> v_arrRaw_Data = FQ_111_NK_sp_sel_List_Raw_By_Nhap_Kho_ID(p_iNhap_Kho_ID);

			ExcelPackage.License.SetNonCommercialOrganization("Công Ty Cổ Phần Logistics WMS");
			using ExcelPackage v_objPackage = new(new FileInfo(p_strTemplate_Path));
			ExcelWorksheet v_objSheet = v_objPackage.Workbook.Worksheets[0];

			v_objSheet.Cells["A1"].Value = CConfig.Company_Name;
			v_objSheet.Cells["A3"].Value = v_objHeader.Ngay_Nhap_Kho.HasValue
				? v_objHeader.Ngay_Nhap_Kho.Value.ToString("dd 'tháng' MM 'năm' yyyy", CultureInfo.GetCultureInfo("vi-VN"))
				: "";
			v_objSheet.Cells["A4"].Value = v_objHeader.So_Phieu_Nhap_Kho;
			v_objSheet.Cells["A5"].Value = v_objHeader.Ten_NCC;
			v_objSheet.Cells["A7"].Value = v_objHeader.Ten_Kho;

			const int v_iFirst_Detail_Row = 12;
			const int v_iTemplate_Detail_Row_Count = 10;
			int v_iExtra_Rows = Math.Max(0, v_arrRaw_Data.Count - v_iTemplate_Detail_Row_Count);
			if (v_iExtra_Rows > 0)
				v_objSheet.InsertRow(22, v_iExtra_Rows, 21);

			for (int v_i = 0; v_i < v_arrRaw_Data.Count; v_i++)
			{
				int v_iRow = v_iFirst_Detail_Row + v_i;
				CDM_Nhap_Kho_Raw_Data v_objRaw = v_arrRaw_Data[v_i];
				v_objSheet.Cells[v_iRow, 1].Value = v_i + 1;
				v_objSheet.Cells[v_iRow, 2].Value = v_objRaw.Ten_San_Pham;
				v_objSheet.Cells[v_iRow, 3].Value = v_objRaw.Ma_San_Pham;
				v_objSheet.Cells[v_iRow, 4].Value = v_objRaw.Ten_Don_Vi_Tinh;
				v_objSheet.Cells[v_iRow, 5].Value = v_objRaw.SL_Nhap;
				v_objSheet.Cells[v_iRow, 6].Value = "";
				v_objSheet.Cells[v_iRow, 7].Value = v_objRaw.Don_Gia_Nhap;
				v_objSheet.Cells[v_iRow, 8].Value = v_objRaw.SL_Nhap * v_objRaw.Don_Gia_Nhap;
			}

			int v_iTotal_Row = v_iFirst_Detail_Row + Math.Max(v_iTemplate_Detail_Row_Count, v_arrRaw_Data.Count);
			v_objSheet.Cells[v_iTotal_Row, 3].Value = "Tổng";
			v_objSheet.Cells[v_iTotal_Row, 5].Value = v_arrRaw_Data.Sum(v_objRaw => v_objRaw.SL_Nhap);
			v_objSheet.Cells[v_iTotal_Row, 8].Value = v_arrRaw_Data.Sum(v_objRaw => v_objRaw.SL_Nhap * v_objRaw.Don_Gia_Nhap);

			decimal v_decTong_Tien = v_arrRaw_Data.Sum(v_objRaw => v_objRaw.SL_Nhap * v_objRaw.Don_Gia_Nhap);
			v_objSheet.Cells[v_iTotal_Row + 2, 1].Value = "Tổng Số Tiền (Viết Bằng Chữ) : " + new CNumber().ReadInt(decimal.Truncate(v_decTong_Tien).ToString("0", CultureInfo.InvariantCulture), "USD");

			return v_objPackage.GetAsByteArray();
		}
	}
}