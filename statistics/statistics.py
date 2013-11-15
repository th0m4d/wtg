#!/usr/bin/env python2.7

import scipy.io
import argparse
import textwrap
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import os
import numpy as np


# of performance vs
# - A graph of Sparsity vs Performance
# - A graph of Dictonary Size vs Performance
# - A graph showing the basis of Dictionaries
# - Confusion matri
# using the cross-validation performance
# also of our work comparing to other
# assume we acchived
# 80% the best
# that will be useful for the presentation
# as well
# and the confusion marrix

def main():
    parser = getParser()
    readCommandLineArguments(parser)


def getParser():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(
            'Creates plots from .mat files for the WTG system.'),
    )
    subparsers = parser.add_subparsers(help=False)
    defineConfusionMatrixParser(subparsers)
    defineSparcityVSPerformanceParser(subparsers)
    defineDictSizePerformanceParser(subparsers)
    defineDictionaryParser(subparsers)
    return parser


def defineConfusionMatrixParser(subparsers):
    confusion_parser = subparsers.add_parser(
        'confusion', help='Create confusion matrix plot')
    confusion_parser.add_argument(
        'path', action='store', help='Path to the .mat file containing the confusion matrix data.')
    confusion_parser.add_argument(
        '-s', '--show', dest='show', action='store_true', help='Shows the figure instead of saving it to a file.')
    confusion_parser.set_defaults(which='confusion')


def defineSparcityVSPerformanceParser(subparsers):
    sparcity_parser = subparsers.add_parser(
        'sparcity', help='Create sparcity performance plot.')
    #sparcity_parser.add_argument('path', action='store', help='Path to the .mat file containing the confusion matrix data.')
    sparcity_parser.add_argument(
        '-s', '--show', dest='show', action='store_true', help='Shows the figure instead of saving it to a file.')
    sparcity_parser.set_defaults(which='sparcity')


def defineDictSizePerformanceParser(subparsers):
    dictsize_parser = subparsers.add_parser(
        'dictsize', help='Create dictionary size performance plot.')
    #dictsize_parser.add_argument('path', action='store', help='Path to the .mat file containing the confusion matrix data.')
    dictsize_parser.add_argument(
        '-s', '--show', dest='show', action='store_true', help='Shows the figure instead of saving it to a file.')
    dictsize_parser.set_defaults(which='dictsize')


def defineDictionaryParser(subparsers):
    dictionary_parser = subparsers.add_parser(
        'dictionary', help='Plot dictionary as heatmap.')
    dictionary_parser.add_argument(
        'files', action='store', nargs='+', help='List of dictionaries as positional arguments (at least one).')
    dictionary_parser.add_argument(
        '-s', '--show', dest='show', action='store_true', help='Shows the figure instead of saving it to a file.')
    dictionary_parser.set_defaults(which='dictionary')


def readCommandLineArguments(parser):
    try:
        args = parser.parse_args()

        if args.which is 'confusion':
            createConfusionPlots(args.path, args.show)
        if args.which is 'sparcity':
            createSparcityPerformancePlot(args.show)
        if args.which is 'dictsize':
            createDictSizePerformancePlot(args.show)
        if args.which is 'dictionary':
            createDictionaryHeatmapPlot(args.files, args.show)

    except IOError as msg:
        parser.error(str(msg))


def createConfusionPlots(path, show):

    if not path:
        raise ValueError("Path to .mat file is missing.")

    conf_arr = scipy.io.loadmat(path)
    conf_data = conf_arr['confusion']

    directory = 'confusion_matrices'
    if not os.path.exists(directory):
        os.makedirs(directory)

    print "creating confusion matrix plots..."

    for i in range(len(conf_data) / 2):
        print "creating plot number " + str(i)
        plot = getConfusionMatrixPlot(
            conf_data[i].tolist(), conf_data[i + 1].tolist())
        if not show:
            plot.savefig(directory + '/confusion_matrix_' + str(i) + '.eps')
        else:
            plot.show()


def getConfusionMatrixPlot(true_labels, predicted_labels):
    # Compute confusion matrix
    cm = confusion_matrix(true_labels, predicted_labels)

    # create figure
    fig = plt.figure()
    plt.clf()
    ax = fig.add_subplot(111)
    ax.set_aspect(1)
    res = ax.imshow(cm, cmap=plt.cm.binary,
                    interpolation='nearest', vmin=0, vmax=10)

    # add color bar
    plt.colorbar(res)

    # annotate confusion entries
    width = len(cm)
    height = len(cm[0])

    for x in xrange(width):
        for y in xrange(height):
            ax.annotate(str(cm[x][y]), xy=(y, x), horizontalalignment='center',
                        verticalalignment='center', color=getFontColor(cm[x][y]))

    # add genres as ticks
    alphabet = ['blues', 'classical', 'country', 'disco',
                'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock']
    plt.xticks(range(width), alphabet[:width], rotation=30)
    plt.yticks(range(height), alphabet[:height])
    return plt


def getFontColor(value):
    if value < 5:
        return "black"
    else:
        return "white"


def createSparcityPerformancePlot(show):
    sparcities = [1, 2, 3]
    performance = [81.69, 74.55, 71.0145]

    plt.figure()
    plt.plot(sparcities, performance, 'r')
    plt.xlabel('Sparcity')
    plt.ylabel('10 Fold Cross Validation Performance')
    plt.title('Performance with different sparcity values.')
    if not show:
            plt.savefig('sparcity_performance.eps')
    else:
        plt.show()


def createDictSizePerformancePlot(show):
    # full cross validation performance
    dict_sizes_sp_1 = [500, 1000, 2000, 3000, 4000]
    cross_validation_performance = [75.02, 78.05, 82.11, 83.43, 83.23]

    # clipwise normalized performance
    clipwise_performance = [79.53, 81.5, 84.26, 85.1, 85.12]

    plt.figure()
    plot1 = plt.plot(
        dict_sizes_sp_1, cross_validation_performance, 'r', label="Frame level Performance")
    plot2 = plt.plot(
        dict_sizes_sp_1, clipwise_performance, 'b', label="Clip level Performance")

    plt.legend(loc=4)

    plt.xlabel('Dictionary Size')
    plt.ylabel('Performance')
    plt.title('Performance with different dictionary sizes.')
    if not show:
            plt.savefig('sparcity_performance.eps')
    else:
        plt.show()


def createDictionaryHeatmapPlot(files, show):
    if not files:
        raise ValueError("No dictionaries were passed as arguments.")

    data = scipy.io.loadmat(files[0])
    dictionary = data['D']
    dictionary = dictionary[0:50]
    dictionary = np.flipud(dictionary)
    dictionaries =dictionary

    for path in files[1:len(files)]:
        data = scipy.io.loadmat(path)
        dictionary = data['D']
        dictionary = dictionary[0:50]
        dictionary = np.flipud(dictionary)
        dictionaries = np.concatenate((dictionaries,dictionary), axis=1)
    print dictionaries.shape

    # create figure
    fig = plt.figure()
    plt.clf()
    ax = fig.add_subplot(111)
    ax.set_aspect(1)
    res = ax.imshow(dictionaries, cmap=plt.cm.jet)
    plt.show()

if __name__ == "__main__":
    main()
