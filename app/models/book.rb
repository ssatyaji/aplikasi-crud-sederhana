class Book < ApplicationRecord
  validates :title, presence: { message: 'Judul harus diisi' }
  validates :page, presence: { message: 'Jumlah halaman harus diisi' }, numericality: {only_integer: true, greater_than_or_equal_to: 10, message: 'Halaman hanya berisi nilai genap dan >= 10'}
  validates :year, presence: { message: 'Tahun harus diisi' }, numericality: {only_integer: true, greater_than_or_equal_to: 1900, message: 'Tahun harus diisi dengan format 4 angka'}
  validates :description, presence: { message: 'Deskripsi harus diisi' }, length: {minimum: 30, message: 'Minimal 30 karakter'}
  validates :state, inclusion: { in: ['active', 'inactive'], message: 'Status tidak valid' }

  def humanize_state
    if state == 'active'
      'aktif'
    else
      'nonaktif'
    end
  end
end
