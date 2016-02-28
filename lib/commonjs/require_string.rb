module CommonJS
  class Environment
    def require_string(module_id, js)
      raise "#{module_id} has already been loaded" if @modules[module_id]
      load_js = "( function(module, require, exports) {\n#{js}\n} )"
      load = @runtime.eval(load_js)
      @modules[module_id] = mod = Module.new(module_id, self)
      load.call(mod, mod.require_function, mod.exports)
      mod.exports
    end
  end
end
