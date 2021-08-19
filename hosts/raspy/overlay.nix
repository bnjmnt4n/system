{ ... }:
{
  hardware.deviceTree = {
    overlays = [
      # # Equivalent to: https://github.com/raspberrypi/linux/blob/rpi-5.10.y/arch/arm/boot/dts/overlays/i2c-bcm2708-overlay.dts
      # {
      #   name = "rpi4-i2c-bcm2708-overlay";
      #   dtsText = ''
      #     /dts-v1/;
      #     /plugin/;

      #     / {
      #       compatible = "brcm,bcm2835";

      #       fragment@0 {
      #         target = <&i2c_arm>;
      #         __overlay__ {
      #           compatible = "brcm,bcm2708-i2c";
      #         };
      #       };
      #     };
      #   '';
      # }

      # Equivalent to: https://github.com/raspberrypi/linux/blob/rpi-5.10.y/arch/arm/boot/dts/overlays/i2c0-overlay.dts
      # {
      #   name = "rpi4-i2c0-overlay";
      #   dtsText = ''
      #     /dts-v1/;
      #     /plugin/;

      #     / {
      #       compatible = "brcm,bcm2835";

      #       fragment@0 {
      #         target = <&i2c0if>;
      #         __overlay__ {
      #           status = "okay";
      #           pinctrl-names = "default";
      #           pinctrl-0 = <&i2c0_pins>;
      #         };
      #       };

      #       fragment@1 {
      #         target = <&i2c0_pins>;
      #         __overlay__ {
      #           brcm,pins = <0 1>;
      #           brcm,function = <4>; /* alt0 */
      #         };
      #       };

      #       fragment@2 {
      #         target = <&i2c0mux>;
      #         __overlay__ {
      #           status = "disabled";
      #         };
      #       };

      #       fragment@3 {
      #         target-path = "/aliases";
      #         __overlay__ {
      #           i2c0 = "/soc/i2c@7e205000";
      #         };
      #       };

      #       fragment@4 {
      #         target-path = "/__symbols__";
      #         __overlay__ {
      #           i2c0 = "/soc/i2c@7e205000";
      #         };
      #       };
      #     };
      #   '';
      # }

      # Equivalent to: https://github.com/raspberrypi/linux/blob/rpi-5.10.y/arch/arm/boot/dts/overlays/i2c1-overlay.dts
      {
        name = "rpi4-i2c1-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2835";

            fragment@0 {
              target = <&i2c1>;
              __overlay__ {
                status = "okay";
                pinctrl-names = "default";
                pinctrl-0 = <&i2c1_pins>;
              };
            };

            fragment@1 {
              target = <&i2c1_pins>;
              __overlay__ {
                brcm,pins = <2 3>;
                brcm,function = <4>; /* alt 0 */
              };
            };
          };
        '';
      }
    ];
  };
}
