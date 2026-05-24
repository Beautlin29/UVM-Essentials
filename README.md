# UVM Essentials
This repository contains a comprehensive collection of Universal Verification Methodology (UVM) practice codes and testbench examples. It serves as a practical sandbox for mastering UVM fundamentals, phasing, sequences, reporting mechanisms, and Transaction Level Modeling (TLM).

## 📌 Overview
The code here bridges the gap between basic SystemVerilog OOP concepts and advanced, standardized verification environment architectures. It focuses on the UVM class library, covering everything from core object methods to complex sequence arbitration and hierarchical component communication.

## 📂 Repository Structure & Topics
The repository files are categorized into the following key UVM domains:

### 1. Core Base Classes & Object Methods
Examples covering UVM field macros, object cloning, comparing, and string conversion for transaction items.

* `uvm_object_field_macros.sv` & `copy_clone_compare_field_macros.sv` - Automating core methods using standard UVM field macros.
* `do_copy_do_compare_method.sv` & `do_print_method.sv` - Manually implementing core `uvm_object` methods for fine-grained control.
* `convert2string_method.sv` - Customizing string representations for debug and reporting.

### 2. Sequences & Sequencer Arbitration
Techniques for generating stimulus, managing sequence execution, and handling complex sequencer access.

* **Sequence Execution:** `creating_sequence.sv`, `sending_multiple_sequences.sv`
* **Sending Methods:** `sending_sequence_method_1.sv`, `sending_sequence_method_2.sv`, `sending_sequence_method_3.sv` - Various macros and methods for executing items (e.g., `uvm_do`, `start_item`/`finish_item`).
* **Access Control & Priority:** `holding_access_of_sequencer_lock.sv`, `holding_access_of_sequencer_grab.sv`, `holding_access_of_sequencer_priority.sv`
* **Arbitration:** `changing_arbitration_mechanism.sv` - Configuring how the sequencer chooses between multiple parallel sequences.

### 3. Transaction Level Modeling (TLM)
Communication mechanisms for passing transactions between independent UVM components without hardcoded connections.

* **Put/Get Operations:** `tlm_put_operation_Port-Imp.sv`, `tlm_get_operation_Port-Imp.sv`
* **Hierarchical Connections:** Examples of routing TLM across multiple layers of the testbench:
    * `tlm_put_operation_Port-Export-Imp.sv`
    * `tlm_put_operation_Port-Export_Subconsumer-Imp.sv`
    * `tlm_put_operation_Port_Subproducer-Port-Imp.sv`
* **Analysis & Transport:** * `tlm_analysis_operation_Port-Multiple_Imp.sv` - Broadcasting transactions to multiple components (like scoreboards/coverage collectors).
    * `tlm_transport_operation_Port-Imp.sv` - Bi-directional communication.

### 4. Phasing & Simulation Control
Managing the UVM timeline, component synchronization, and simulation shutdown.

* `uvm_phases.sv` - Exploring the execution order of standard UVM phases (build, connect, run, extract, etc.).
* `drain_time-individual_component.sv` & `drain_time-multiple_components.sv` - Managing objection drain times before dropping to the next phase.
* `timeout.sv` - Handling global simulation timeouts to prevent hangs.

### 5. Reporting Mechanism
Controlling UVM messages, verbosity levels, action overrides, and logging.

* **Basic Macros & Actions:** `reporting_macros.sv`, `other_reporting_macros.sv`, `uvm_associated_actions_of_macros.sv`
* **Verbosity Control:** Filtering logs based on importance and hierarchy:
    * `set_verbosity_level_with_component.sv`
    * `set_verbosity_level_with_hierarchy.sv`
    * `set_verbosity_level_with_id.sv`
* **Overrides & Logging:** * `severity_override.sv` - Upgrading/downgrading message severity on the fly.
    * `uvm_log_file.sv` - Directing UVM reports to specific log files.
    * `uvm_error_and_quit_count.sv` - Setting thresholds for maximum allowed simulation errors.

### 6. Factory & Configuration Database
Dynamic object creation and top-down hierarchical testbench configuration.

* `factory_override.sv` - Using type and instance overrides to swap components or transactions without modifying original code.
* `uvm_config_db` - Passing configuration objects and virtual interfaces down the UVM hierarchy.
* `print_topology.sv` - Extracting and displaying the complete UVM testbench tree structure.
