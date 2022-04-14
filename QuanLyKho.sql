CREATE DATABASE QuanLyKho
USE QuanLyKho
GO
CREATE TABLE LoaiHang(
MaLoaiHang INT PRIMARY KEY,
TenLoaiHang NVARCHAR(30) NOT NULL UNIQUE

)
CREATE TABLE DonViTinh(
MaDonViTinh INT PRIMARY KEY,
TenDonViTinh NVARCHAR(30) NOT NULL UNIQUE
)
CREATE TABLE HangHoa(
MaHangHoa INT PRIMARY KEY,
TenHangHoa NVARCHAR(30) NOT NULL UNIQUE,
MaLoaiHang INT NOT NULL REFERENCES LoaiHang(MaLoaiHang)
)
CREATE TABLE Kho(
MaKho INT PRIMARY KEY,
TenKho NVARCHAR(30) NOT NULL UNIQUE,
DiaChi NVARCHAR(100) NOT NULL

)
CREATE TABLE NhaCungCap(
MaNhaCungCap INT PRIMARY KEY,
TenNhaCungCap NVARCHAR(50) NOT NULL UNIQUE,
DiaChi NVARCHAR(100) NOT NULL
)
CREATE TABLE PhieuNhap(
MaPhieuNhap INT PRIMARY KEY,
NgayNhap DATE NOT NULL,
NguoiLap NVARCHAR(30) NOT NULL,
MaNhaCungCap INT NOT NULL REFERENCES NhaCungCap(MaNhaCungCap),
MaKho INT NOT NULL REFERENCES Kho(MaKho)

)
CREATE TABLE ChiTietPhieuNhap(
MaPhieuNhap INT NOT NULL REFERENCES PhieuNhap(MaPhieuNhap),
MaHangHoa INT NOT NULL REFERENCES HangHoa(MaHangHoa),
SoLuong FLOAT NOT NULL,
MaDonViTinh INT NOT NULL REFERENCES DonViTinh(MaDonViTinh),
DonGia FLOAT NOT NULL,
CONSTRAINT PK_ChiTietPhieuNhap PRIMARY KEY(MaPhieuNhap,MaHangHoa),
CONSTRAINT CK_ChiTietPhieuNhap CHECK(SoLuong > 0 AND DonGia >= 0)
)
INSERT LoaiHang VALUES(1, N'Thực phẩm')
INSERT LoaiHang VALUES(2, N'Điện tử')
INSERT LoaiHang VALUES(3, N'Hóa chất')
INSERT DonViTinh VALUES(1, N'Chiếc')
INSERT DonViTinh VALUES(2, N'KG')
INSERT DonViTinh VALUES(3, N'Lit')
INSERT HangHoa VALUES(1,N'Thịt bò',1)
INSERT HangHoa VALUES(2,N'Thịt lợn',1)
INSERT HangHoa VALUES(3,N'Thuốc trừ sâu',3)
INSERT Kho VALUES(1,N'Kho lương thực',N'43 Đà Nẵng, Hải Phòng')
INSERT Kho VALUES(2,N'Kho điện tử',N'44 Đà Nẵng, Hải Phòng')
INSERT Kho VALUES(3,N'Kho hóa chất',N'45 Đà Nẵng, Hải Phòng')
INSERT NhaCungCap VALUES(1,N'Thịt sạch',N'43 Đông Khê, Hải Phòng')
INSERT NhaCungCap VALUES(2,N'Thịt tươi',N'44 Đông Khê, Hải Phòng')
INSERT NhaCungCap VALUES(3,N'Thịt ngon',N'46 Đông Khê, Hải Phòng')
INSERT PhieuNhap VALUES(1,'2022/3/15',N'Lê An',1,1)
INSERT PhieuNhap VALUES(2,'2022/3/14',N'Lê Bình',2,1)
INSERT PhieuNhap VALUES(3,'2022/3/13',N'Lê An',3,1)
INSERT ChiTietPhieuNhap VALUES(1,1,10,2,50000)
INSERT ChiTietPhieuNhap VALUES(1,2,20,2,40000)
INSERT ChiTietPhieuNhap VALUES(2,1,10,2,55000)
INSERT ChiTietPhieuNhap VALUES(3,2,30,2,45000)
SELECT MaHangHoa,TenHangHoa,TenLoaiHang 
FROM HangHoa
INNER JOIN LoaiHang
ON HangHoa.MaLoaiHang = LoaiHang.MaLoaiHang
SELECT NhaCungCap.MaNhaCungCap,TenNhaCungCap,COUNT(MaPhieuNhap) AS SoPhieuNhap
FROM NhaCungCap
INNER JOIN PhieuNhap
ON NhaCungCap.MaNhaCungCap = PhieuNhap.MaNhaCungCap
GROUP BY NhaCungCap.MaNhaCungCap, TenNhaCungCap
SELECT Kho.MaKho, TenKho, COUNT(MaPhieuNhap) AS SoPhieuNhap
FROM Kho
INNER JOIN PhieuNhap
ON Kho.MaKho = PhieuNhap.MaKho
GROUP BY Kho.MaKho,TenKho
SELECT PhieuNhap.MaPhieuNhap, NgayNhap, TenNhaCungCap,TenKho,SUM(SoLuong * DonGia) AS TongGiaTri
FROM ChiTietPhieuNhap
INNER JOIN PhieuNhap ON PhieuNhap.MaPhieuNhap = ChiTietPhieuNhap.MaPhieuNhap
INNER JOIN Kho ON Kho.MaKho = PhieuNhap.MaKho
INNER JOIN NhaCungCap ON NhaCungCap.MaNhaCungCap = PhieuNhap.MaNhaCungCap
GROUP BY PhieuNhap.MaPhieuNhap,NgayNhap, TenNhaCungCap, TenKho