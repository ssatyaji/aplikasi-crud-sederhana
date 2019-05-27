class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  rescue_from ActiveRecord::RecordNotFound, with: :book_not_found

  def show
    @book = book_current
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, notice: 'Buku Tidak Tersedia'
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.state = 'active'

    if @book.save
      redirect_to books_path, notice: "Buku #{@book.title} berhasil disimpan"
    else
      render 'new'
    end
  end

  def edit
    @book = book_current
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, notice: 'Buku tidak tersedia'  
  end

  def update
    @book = book_current

    if @book.update(book_params)
      redirect_to books_path, notice: 'Berhasil memperbarui databuku'
    else
      render 'edit'
    end
  end

  def destroy
    book = book_current
    book.destroy

    redirect_to books_path, notice: "Berhasil menghapus buku #{book.title}"
  end

  def home
    render plain: 'Ini action home'
  end

  def toggle_status
    books = Book.first(3)

    response = {
      data: build_books(books)
    }

    render json: response
  end

  def status
    if book_current.update(state: params[:state])
      redirect_to book_path(book_current), notice: "Status buku berhasil diperbarui"
    else
      redirect_to book_path(book_current), notice: "Status buku gagal diperbarui" 
    end
  end

  private

  def build_books(books)
    books.map do |book|
      {
        id: book.id,
        title: book.title,
        page: book.page,
        year: book.year,
        description: book.description
      }
    end
  end

  def book_params
    params.require(:book).permit(:title, :page, :year, :description)
  end

  def book_current
    @book ||= Book.find(params[:id])
  end

  def book_not_found
    redirect_to books_path, notice: 'Buku tidak tersedia'    
  end
end