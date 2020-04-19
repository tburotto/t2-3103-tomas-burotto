class HamburguesaController < ApplicationController
    def index
        @hamburguesas = Hamburguesa.all
        @result = []
        @hamburguesas.each do |hamburguesa|
            item = {
                "id" => hamburguesa.id,
                "nombre" => hamburguesa.nombre,
                "precio" => hamburguesa.precio,
                "descripcion" => hamburguesa.descripcion,
                "imagen" => hamburguesa.imagen,
                "ingredientes" => []
            }
            
            hamburguesa.ingredientes.each do |ingrediente|
                item["ingredientes"] << {"path" => "http://localhost:3000/ingrediente/"+ingrediente.id.to_s}
            end
            @result << item
        end
        render json: @result, status: :ok
    end

    def create
        begin
            body = JSON.parse(request.body.read)
            if body.keys == ["nombre", "precio", "descripcion", "imagen"]
                @hamburguesa = Hamburguesa.new(nombre: body["nombre"], precio: body["precio"].to_i, imagen: body["imagen"], descripcion: body["descripcion"])
                @hamburguesa.save
                @respuesta = {
                    "id" => @hamburguesa.id,
                    "nombre" => @hamburguesa.nombre,
                    "precio" => @hamburguesa.precio,
                    "descripcion" => @hamburguesa.descripcion,
                    "imagen" => @hamburguesa.imagen,
                    "ingredientes" => []
                }
                @hamburguesa.ingredientes.each do |ingrediente|
                    @respuesta['ingredientes'] << {"path" => "http://localhost:3000/ingrediente/"+ingrediente.id.to_s}
                end
                render json: @respuesta, status: :created
            else 
                render json: {"message" => "input invalido"}, status: :bad_request
            end
        rescue
            render json: {"message" => "input invalido"}, status: :bad_request
        end
    end

    def show
        id = params["id"]
        if id.to_i.to_s == id
            @hamburguesa = Hamburguesa.find_by(id: params["id"])
            if @hamburguesa
                @respuesta = {
                    "id" => @hamburguesa.id,
                    "nombre" => @hamburguesa.nombre,
                    "precio" => @hamburguesa.precio,
                    "descripcion" => @hamburguesa.descripcion,
                    "imagen" => @hamburguesa.imagen,
                    "ingredientes" => []
                }
                @hamburguesa.ingredientes.each do |ingrediente|
                    @respuesta['ingredientes'] << {"path" => "http://localhost:3000/ingrediente/"+ingrediente.id.to_s}
                end
                render json: @respuesta, status: :ok
            else
                render json: {"message" => "Hamburguesa no encontrada"}, status: :not_found
            end
        else
            render json: {"message" => "id no valido"}, status: :bad_request
        end
    end

    def update
        begin
            body = JSON.parse(request.body.read)
            id = params["id"]
            if id.to_i.to_s == id
                if @hamburguesa = Hamburguesa.find_by(id: params["id"])
                    @hamburguesa.nombre = body["nombre"]
                    @hamburguesa.precio = body["precio"]
                    @hamburguesa.descripcion = body["descripcion"]
                    @hamburguesa.imagen = body["imagen"]
                    @hamburguesa.save

                    @respuesta = {
                        "id" => @hamburguesa.id,
                        "nombre" => @hamburguesa.nombre,
                        "precio" => @hamburguesa.precio,
                        "descripcion" => @hamburguesa.descripcion,
                        "imagen" => @hamburguesa.imagen,
                        "ingredientes" => []
                    }
                    @hamburguesa.ingredientes.each do |ingrediente|
                        @respuesta['ingredientes'] << {"path" => "http://localhost:3000/ingrediente/"+ingrediente.id.to_s}
                    end
                    render json: @respuesta, status: :ok
                else 
                    render json: {"message": "hamburguesa inexistente"}, status: :not_found
                end
            else
                render json: {"message": "id no valido"}, status: :bad_request
            end
        rescue
            render json: {"message": "input no valido"}, status: :bad_request
        end
    end

    def destroy
        id = params["id"]
        if id.to_i.to_s == id
            if @hamburguesa = Hamburguesa.find_by(id: params["id"])
                @hamburguesa.destroy

                render json: {"message": "eliminado exitosamente"}, status: :ok
            else
                render json: {"message": "hamburguesa inexistente"}, status: :not_found
            end
        else
            render json: {"message": "id no valido"}, status: :bad_request
        end
    end

    def editingrediente
        id_hamburguesa = params[:id_hamburguesa].to_i
        id_ingrediente = params[:id_ingrediente].to_i
        @hamburguesa = Hamburguesa.find_by(id: id_hamburguesa)
        @ingrediente = Ingrediente.find_by(id: id_ingrediente)

        @hamburguesa.ingredientes << @ingrediente

        @hamburguesa.save

        render json: @hamburguesa, status: :ok

    end
end

private

def hamburguesa_params
    params.require(:hamburguesa).permit(:nombre, :precio, :descripcion, :imagen)
end
