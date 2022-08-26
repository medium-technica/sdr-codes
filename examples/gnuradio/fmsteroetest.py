#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: FM Stereo Test
# GNU Radio version: 3.9.5.0

from distutils.version import StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()")

from gnuradio import analog
from gnuradio import audio
from gnuradio import blocks
from gnuradio import filter
from gnuradio.filter import firdes
from gnuradio import gr
from gnuradio.fft import window
import sys
import signal
from PyQt5 import Qt
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import soapy
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore
import math



from gnuradio import qtgui

class fmsteroetest(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "FM Stereo Test", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("FM Stereo Test")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "fmsteroetest")

        try:
            if StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
                self.restoreGeometry(self.settings.value("geometry").toByteArray())
            else:
                self.restoreGeometry(self.settings.value("geometry"))
        except:
            pass

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 250e3
        self.lpr = lpr = 0.5
        self.lmr = lmr = 0.5
        self.freq = freq = 91.9e6

        ##################################################
        # Blocks
        ##################################################
        self._lpr_range = Range(0, 1, 0.1, 0.5, 200)
        self._lpr_win = RangeWidget(self._lpr_range, self.set_lpr, "L + R", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._lpr_win)
        self._lmr_range = Range(0, 300, 1, 0.5, 200)
        self._lmr_win = RangeWidget(self._lmr_range, self.set_lmr, "L - R", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._lmr_win)
        self._freq_range = Range(88e6, 107e6, 0.1e6, 91.9e6, 200)
        self._freq_win = RangeWidget(self._freq_range, self.set_freq, "FM Channel Frequency", "counter_slider", float, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._freq_win)
        self.soapy_rtlsdr_source_0 = None
        dev = 'driver=rtlsdr'
        stream_args = ''
        tune_args = ['']
        settings = ['']

        self.soapy_rtlsdr_source_0 = soapy.source(dev, "fc32", 1, '',
                                  stream_args, tune_args, settings)
        self.soapy_rtlsdr_source_0.set_sample_rate(0, samp_rate)
        self.soapy_rtlsdr_source_0.set_gain_mode(0, False)
        self.soapy_rtlsdr_source_0.set_frequency(0, freq)
        self.soapy_rtlsdr_source_0.set_frequency_correction(0, 0)
        self.soapy_rtlsdr_source_0.set_gain(0, 'TUNER', 20)
        self.low_pass_filter_0_0 = filter.fir_filter_fff(
            10,
            firdes.low_pass(
                1,
                samp_rate,
                15e3,
                1e3,
                window.WIN_BLACKMAN,
                6.76))
        self.low_pass_filter_0 = filter.fir_filter_fff(
            10,
            firdes.low_pass(
                1,
                samp_rate,
                15e3,
                1e3,
                window.WIN_BLACKMAN,
                6.76))
        self.blocks_sub_xx_0 = blocks.sub_ff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vff(1)
        self.blocks_multiply_const_vxx_0_0_0 = blocks.multiply_const_ff(lpr)
        self.blocks_multiply_const_vxx_0_0 = blocks.multiply_const_ff(lmr)
        self.blocks_float_to_complex_0_0 = blocks.float_to_complex(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_complex_to_float_0 = blocks.complex_to_float(1)
        self.blocks_add_xx_0 = blocks.add_vff(1)
        self.band_pass_filter_0_1 = filter.fir_filter_fff(
            1,
            firdes.band_pass(
                10,
                samp_rate,
                23e3,
                53e3,
                1e2,
                window.WIN_BLACKMAN,
                6.76))
        self.band_pass_filter_0_0 = filter.fir_filter_ccf(
            1,
            firdes.band_pass(
                1,
                samp_rate,
                37.5e3,
                38.5e3,
                1e2,
                window.WIN_BLACKMAN,
                6.76))
        self.band_pass_filter_0 = filter.fir_filter_fff(
            1,
            firdes.band_pass(
                1,
                samp_rate,
                18.5e3,
                19.5e3,
                1e2,
                window.WIN_BLACKMAN,
                6.76))
        self.audio_sink_0 = audio.sink(25000, '', True)
        self.analog_wfm_rcv_0 = analog.wfm_rcv(
        	quad_rate=samp_rate,
        	audio_decimation=1,
        )
        self.analog_pll_freqdet_cf_0 = analog.pll_freqdet_cf(2*math.pi/100, 2*math.pi / (samp_rate/19.5e3), 2*math.pi / (samp_rate/18.5e3))


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_pll_freqdet_cf_0, 0), (self.blocks_float_to_complex_0_0, 0))
        self.connect((self.analog_wfm_rcv_0, 0), (self.band_pass_filter_0, 0))
        self.connect((self.analog_wfm_rcv_0, 0), (self.band_pass_filter_0_1, 0))
        self.connect((self.analog_wfm_rcv_0, 0), (self.low_pass_filter_0, 0))
        self.connect((self.band_pass_filter_0, 0), (self.blocks_float_to_complex_0, 0))
        self.connect((self.band_pass_filter_0_0, 0), (self.blocks_complex_to_float_0, 0))
        self.connect((self.band_pass_filter_0_1, 0), (self.blocks_multiply_xx_0, 1))
        self.connect((self.blocks_add_xx_0, 0), (self.audio_sink_0, 1))
        self.connect((self.blocks_complex_to_float_0, 0), (self.blocks_multiply_xx_0, 0))
        self.connect((self.blocks_float_to_complex_0, 0), (self.analog_pll_freqdet_cf_0, 0))
        self.connect((self.blocks_float_to_complex_0_0, 0), (self.band_pass_filter_0_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_0, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.blocks_multiply_const_vxx_0_0, 0), (self.blocks_sub_xx_0, 1))
        self.connect((self.blocks_multiply_const_vxx_0_0_0, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_0_0, 0), (self.blocks_sub_xx_0, 0))
        self.connect((self.blocks_multiply_xx_0, 0), (self.low_pass_filter_0_0, 0))
        self.connect((self.blocks_sub_xx_0, 0), (self.audio_sink_0, 0))
        self.connect((self.low_pass_filter_0, 0), (self.blocks_multiply_const_vxx_0_0_0, 0))
        self.connect((self.low_pass_filter_0_0, 0), (self.blocks_multiply_const_vxx_0_0, 0))
        self.connect((self.soapy_rtlsdr_source_0, 0), (self.analog_wfm_rcv_0, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "fmsteroetest")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_pll_freqdet_cf_0.set_max_freq(2*math.pi / (self.samp_rate/19.5e3))
        self.analog_pll_freqdet_cf_0.set_min_freq(2*math.pi / (self.samp_rate/18.5e3))
        self.band_pass_filter_0.set_taps(firdes.band_pass(1, self.samp_rate, 18.5e3, 19.5e3, 1e2, window.WIN_BLACKMAN, 6.76))
        self.band_pass_filter_0_0.set_taps(firdes.band_pass(1, self.samp_rate, 37.5e3, 38.5e3, 1e2, window.WIN_BLACKMAN, 6.76))
        self.band_pass_filter_0_1.set_taps(firdes.band_pass(10, self.samp_rate, 23e3, 53e3, 1e2, window.WIN_BLACKMAN, 6.76))
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, 15e3, 1e3, window.WIN_BLACKMAN, 6.76))
        self.low_pass_filter_0_0.set_taps(firdes.low_pass(1, self.samp_rate, 15e3, 1e3, window.WIN_BLACKMAN, 6.76))
        self.soapy_rtlsdr_source_0.set_sample_rate(0, self.samp_rate)

    def get_lpr(self):
        return self.lpr

    def set_lpr(self, lpr):
        self.lpr = lpr
        self.blocks_multiply_const_vxx_0_0_0.set_k(self.lpr)

    def get_lmr(self):
        return self.lmr

    def set_lmr(self, lmr):
        self.lmr = lmr
        self.blocks_multiply_const_vxx_0_0.set_k(self.lmr)

    def get_freq(self):
        return self.freq

    def set_freq(self, freq):
        self.freq = freq
        self.soapy_rtlsdr_source_0.set_frequency(0, self.freq)




def main(top_block_cls=fmsteroetest, options=None):

    if StrictVersion("4.5.0") <= StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
