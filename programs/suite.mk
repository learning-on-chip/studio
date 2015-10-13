define declare_program
$(2)_output := $${OUTPUT_ROOT}/$(2)
$(2)_options = -d $${$(2)_output} $$(shell ./configure.py $(2))

$(2): $${$(2)_output}/.done

$${$(2)_output}/.done:
	@mkdir -p $${$(2)_output}
	@echo "Running $(1)-$(2)..."
	@echo "Arguments: $${$(2)_options}"
	@(cd $${$(2)_output} && PROGRAM_NAME=$(2) $${SNIPER_BIN} $${SNIPER_OPTIONS} $${$(2)_options})
	@echo "Finished $(1)-$(2)."
	@touch $$@

$(2)-clean:
	@rm -rf $${$(2)_output}

$(2)-kill:
	@killall -q -KILL -- $(2) || true

.PHONY: $(2) $(2)-clean $(2)-kill
endef

define declare_suite
$(foreach program,$(2),$(eval $(call declare_program,$(1),$(program))))

clean: $(addsuffix -clean,$(2))

kill: $(addsuffix -kill,$(2))

.PHONY: all clean kill
endef